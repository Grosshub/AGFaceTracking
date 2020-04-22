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
struct ProcessScene: ProcessSceneProtocol {
    
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
            
            return CurrentValueSubject(SCNNode(geometry: faceGeometry)).eraseToAnyPublisher()
            
        case .put3DmodelOnFace:
            return CurrentValueSubject(SCNReferenceNode(named: "overlayModel")).eraseToAnyPublisher()
        case .some(.none):
            return CurrentValueSubject(nil).eraseToAnyPublisher()
        case .none:
            return Fail(error: .unknown).eraseToAnyPublisher()
        }
    }
}
