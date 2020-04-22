//
//  ProcessScene.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit
import Combine

// Use case responsible for SceneKit renderer processing
class ProcessScene: ProcessSceneProtocol {
    
    private var originalJawY: Float = 0
    
    func sceneKitNode(for renderer: SCNSceneRenderer, anchor: ARAnchor, mode: FaceTrackingMode?) -> AnyPublisher<SCNNode?, ARConfiguratorError> {
        
        guard let sceneView = renderer as? ARSCNView else {
            return Fail(error: .wrongRenderer).eraseToAnyPublisher()
        }
        
        guard anchor is ARFaceAnchor else {
            return Fail(error: .wrongAnchor).eraseToAnyPublisher()
        }
        
        switch mode?.type {
        case .put2DMaskOnFace:

            let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
            let material = faceGeometry.firstMaterial!
            
            material.diffuse.contents = #imageLiteral(resourceName: "wireframeTexture")
            material.lightingModel = .physicallyBased
            
            let node = SCNNode(geometry: faceGeometry)
            
            return CurrentValueSubject(node).eraseToAnyPublisher()
            
        case .put3DmodelOnFace:
            return CurrentValueSubject(SCNReferenceNode(named: "eyes")).eraseToAnyPublisher()
        case .animateWithBlendShapes:

            let node = SCNReferenceNode(named: "robot")
            let jawNode = node.childNode(withName: "jaw", recursively: true)!
            originalJawY = jawNode.position.y
            return CurrentValueSubject(node).eraseToAnyPublisher()

        case .some(.none):
            return CurrentValueSubject(nil).eraseToAnyPublisher()
        case .none:
            return Fail(error: .unknown).eraseToAnyPublisher()
        }
    }
}

// MARK: - Process multiple nodes
extension ProcessScene {
    
    func animateBlendShapes(for renderer: SCNSceneRenderer, anchor: ARAnchor, mode: FaceTrackingMode?, updatedNode: SCNNode?) -> AnyPublisher<Bool, ARConfiguratorError> {

        guard renderer is ARSCNView else {
            return Fail(error: .wrongRenderer).eraseToAnyPublisher()
        }
        
        guard let anchor = anchor as? ARFaceAnchor else {
            return Fail(error: .wrongAnchor).eraseToAnyPublisher()
        }
        
        guard let updatedNode = updatedNode else {
            return Fail(error: .wrongNode).eraseToAnyPublisher()
        }
        
        
        let blendShapes = anchor.blendShapes
        
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float,
            let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float,
            let jawOpen = blendShapes[.jawOpen] as? Float else {

                return Fail(error: .incorrectBlendShapes).eraseToAnyPublisher()
        }
        
        let eyeLeftNode = updatedNode.childNode(withName: "eyeLeft", recursively: true)!
        let eyeRightNode = updatedNode.childNode(withName: "eyeRight", recursively: true)!
        let jawNode = updatedNode.childNode(withName: "jaw", recursively: true)!
        
        eyeLeftNode.scale.z = 1 - eyeBlinkLeft
        eyeRightNode.scale.z = 1 - eyeBlinkRight
        
        let (min, max) = jawNode.boundingBox
        let jawHeight: Float = max.y - min.y
        
        jawNode.position.y = originalJawY - jawHeight * jawOpen
        
        return CurrentValueSubject(true).eraseToAnyPublisher()
    }
}
