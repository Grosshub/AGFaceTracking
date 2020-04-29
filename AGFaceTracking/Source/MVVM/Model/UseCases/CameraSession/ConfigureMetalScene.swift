//
//  ConfigureMetalScene.swift
//  AGFaceTrackingApp
//
//  Created by Alexey Gross on 2020-04-29.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Combine
import AVFoundation
import UIKit
import MetalKit

/// Business rule responsible for 3D scene configuration to start a live preview from camera device
class ConfigureMetalScene: NSObject, ConfigureMetalSceneProtocol {
    
    var renderingEnabled: Bool = true
    var isConfigured: Bool = false
    
    private var metalScene: MetalScenePreviewProtocol?
    private let session = AVCaptureSession()
    private var captureDevice: AVCaptureDevice!
    private var videoDeviceInput: AVCaptureDeviceInput!
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private let metadataOutput = AVCaptureMetadataOutput()
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer?
    private var depthCutOff: Float = 1.0
    private var blurRadius: Float = 5.3
    private var gamma: Float = 0.55
    private var greenScreenImage: CIImage?
    
    private var cameraSessionStatus: CameraSessionStatus = .success
    private let dataOutputQueue = DispatchQueue(label: "video data queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera],
                                                                               mediaType: .video,
                                                                               position: .front)
    
    func configureMetalScene(metalScene: MetalScenePreviewProtocol, greenScreenImage: CIImage?, renderingEnabled: Bool) -> AnyPublisher<Bool, MetalSessionError> {
        
        self.renderingEnabled = renderingEnabled
        self.greenScreenImage = greenScreenImage
        
        DispatchQueue.main.async {
            self.metalScene?.enableSetNeedsDisplay = renderingEnabled
            self.metalScene?.isPaused = !renderingEnabled
            self.metalScene?.isHidden = !renderingEnabled
        }
        
        if !renderingEnabled || isConfigured {
            
            if renderingEnabled { self.session.startRunning() }
            return CurrentValueSubject(isConfigured).eraseToAnyPublisher()
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                
                if !granted {
                    self.cameraSessionStatus = .notAuthorized
                }
            })
            
        default:
            cameraSessionStatus = .notAuthorized
        }
        
        self.metalScene = metalScene
        metalScene.configureMetal()
        
        return self.configureSession()
    }
}

// MARK: - Configuration 
extension ConfigureMetalScene {
    
    private func configureSession() -> AnyPublisher<Bool, MetalSessionError> {
        
        if cameraSessionStatus != .success {
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        let defaultVideoDevice: AVCaptureDevice? = videoDeviceDiscoverySession.devices.first
        
        guard let videoDevice = defaultVideoDevice else {
            print("Could not find any video device")
            cameraSessionStatus = .configurationFailed
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        captureDevice = videoDevice
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            print("Could not create video device input: \(error)")
            cameraSessionStatus = .configurationFailed
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        // Add a video input
        guard session.canAddInput(videoDeviceInput) else {
            print("Could not add video device input to the session")
            cameraSessionStatus = .configurationFailed
            session.commitConfiguration()
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        session.addInput(videoDeviceInput)
        
        // Add a video data output
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        } else {
            print("Could not add video data output to the session")
            cameraSessionStatus = .configurationFailed
            session.commitConfiguration()
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        // Add a depth data output
        if session.canAddOutput(depthDataOutput) {
            session.addOutput(depthDataOutput)
            depthDataOutput.isFilteringEnabled = true
            if let connection = depthDataOutput.connection(with: .depthData) {
                connection.isEnabled = true
            } else {
                print("No AVCaptureConnection")
            }
        } else {
            print("Could not add depth data output to the session")
            cameraSessionStatus = .configurationFailed
            session.commitConfiguration()
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        // Search for highest resolution with floating-point depth values
        let depthFormats = videoDevice.activeFormat.supportedDepthDataFormats
        let depth32formats = depthFormats.filter({
            CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat32
        })
        if depth32formats.isEmpty {
            print("Device does not support Float32 depth format")
            cameraSessionStatus = .configurationFailed
            session.commitConfiguration()
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        let selectedFormat = depth32formats.max(by: { first, second in
            CMVideoFormatDescriptionGetDimensions(first.formatDescription).width <
                CMVideoFormatDescriptionGetDimensions(second.formatDescription).width })
        
        do {
            try videoDevice.lockForConfiguration()
            videoDevice.activeDepthDataFormat = selectedFormat
            videoDevice.unlockForConfiguration()
        } catch {
            print("Could not lock device for configuration: \(error)")
            cameraSessionStatus = .configurationFailed
            session.commitConfiguration()
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        if self.session.canAddOutput(metadataOutput) {
            self.session.addOutput(metadataOutput)
            if metadataOutput.availableMetadataObjectTypes.contains(.face) {
                metadataOutput.metadataObjectTypes = [.face]
            }
        } else {
            print("Could not add face detection output to the session")
            cameraSessionStatus = .configurationFailed
            session.commitConfiguration()
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
        
        // Use an AVCaptureDataOutputSynchronizer to synchronize the video data and depth data outputs.
        // The first output in the dataOutputs array, in this case the AVCaptureVideoDataOutput, is the "master" output.
        outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput, metadataOutput])
        outputSynchronizer!.setDelegate(self, queue: dataOutputQueue)
        session.commitConfiguration()
        
        switch self.cameraSessionStatus {
        case .success:
            self.session.startRunning()
            isConfigured = true
            return CurrentValueSubject(isConfigured).eraseToAnyPublisher()
            
        case .notAuthorized:
            isConfigured = false
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
            
        case .configurationFailed:
            isConfigured = false
            return Fail(error: .cameraIsNotAuthorized).eraseToAnyPublisher()
        }
    }
}

// MARK: - Capture data synchronizer
extension ConfigureMetalScene: AVCaptureDataOutputSynchronizerDelegate {
    
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        
        // Read all outputs
        guard renderingEnabled,
            let syncedDepthData: AVCaptureSynchronizedDepthData =
            synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData,
            let syncedVideoData: AVCaptureSynchronizedSampleBufferData =
            synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData else {
                // only work on synced pairs
                return
        }
        if syncedDepthData.depthDataWasDropped || syncedVideoData.sampleBufferWasDropped {
            return
        }
        
        let depthPixelBuffer = syncedDepthData.depthData.depthDataMap
        guard let videoPixelBuffer = CMSampleBufferGetImageBuffer(syncedVideoData.sampleBuffer) else {
            return
        }
        
        // Check if there's a face in the scene. If so - use it to decide on depth cutoff
        if let syncedMetaData: AVCaptureSynchronizedMetadataObjectData = synchronizedDataCollection.synchronizedData(for: metadataOutput) as? AVCaptureSynchronizedMetadataObjectData,
            let firstFace = syncedMetaData.metadataObjects.first,
            let connection = self.videoDataOutput.connection(with: AVMediaType.video),
            let face = videoDataOutput.transformedMetadataObject(for: firstFace, connection: connection) {
            
            let faceCenter = CGPoint(x: face.bounds.midX, y: face.bounds.midY)
            let scaleFactor = CGFloat(CVPixelBufferGetWidth(depthPixelBuffer)) / CGFloat(CVPixelBufferGetWidth(videoPixelBuffer))
            let pixelX = Int((faceCenter.x * scaleFactor).rounded())
            let pixelY = Int((faceCenter.y * scaleFactor).rounded())
            
            CVPixelBufferLockBaseAddress(depthPixelBuffer, .readOnly)
            
            let rowData = CVPixelBufferGetBaseAddress(depthPixelBuffer)! + pixelY * CVPixelBufferGetBytesPerRow(depthPixelBuffer)
            let faceCenterDepth = rowData.assumingMemoryBound(to: Float32.self)[pixelX]
            CVPixelBufferUnlockBaseAddress(depthPixelBuffer, .readOnly)
            self.depthCutOff = faceCenterDepth + 0.25
        }
        
        // Convert depth map in-place: every pixel above cutoff is converted to 1. otherwise it's 0
        let depthWidth = CVPixelBufferGetWidth(depthPixelBuffer)
        let depthHeight = CVPixelBufferGetHeight(depthPixelBuffer)
        
        CVPixelBufferLockBaseAddress(depthPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        for yMap in 0 ..< depthHeight {
            let rowData = CVPixelBufferGetBaseAddress(depthPixelBuffer)! + yMap * CVPixelBufferGetBytesPerRow(depthPixelBuffer)
            let data = UnsafeMutableBufferPointer<Float32>(start: rowData.assumingMemoryBound(to: Float32.self), count: depthWidth)
            for index in 0 ..< depthWidth {
                if data[index] > 0 && data[index] <= depthCutOff {
                    data[index] = 1.0
                } else {
                    data[index] = 0.0
                }
            }
        }
        CVPixelBufferUnlockBaseAddress(depthPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        // Create the mask from that pixel buffer.
        let depthMaskImage = CIImage(cvPixelBuffer: depthPixelBuffer, options: [:])
        
        // Smooth edges to create an alpha matte, then upscale it to the RGB resolution.
        let alphaUpscaleFactor = Float(CVPixelBufferGetWidth(videoPixelBuffer)) / Float(depthWidth)
        let alphaMatte = depthMaskImage.clampedToExtent()
            .applyingFilter("CIGaussianBlur", parameters: ["inputRadius": blurRadius])
            .applyingFilter("CIGammaAdjust", parameters: ["inputPower": gamma])
            .cropped(to: depthMaskImage.extent)
            .applyingFilter("CIBicubicScaleTransform", parameters: ["inputScale": alphaUpscaleFactor])
        let image = CIImage(cvPixelBuffer: videoPixelBuffer)
        
        // Apply alpha matte to the video.
        var parameters = ["inputMaskImage": alphaMatte]
        if let background = self.greenScreenImage {
            parameters["inputBackgroundImage"] = background
        }
        
        let output = image.applyingFilter("CIBlendWithMask", parameters: parameters)
        metalScene?.image = output
    }
}
