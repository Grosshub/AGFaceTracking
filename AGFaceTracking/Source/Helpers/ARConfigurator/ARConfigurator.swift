//
//  ARConfigurator.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit

/// Manages AR session
class ARConfigurator: NSObject, ARConfiguratorProtocol {
    
    private unowned var viewModel: ARViewModelProtocol
    
    required init(viewModel: ViewModelProtocol) {
        
        guard let viewModel = viewModel as? ARViewModelProtocol else {
            fatalError()
        }
        
        self.viewModel = viewModel
    }
    
    func setupARSession(for view: ARSCNView) -> Result<Bool, ARConfiguratorError> {
        
        view.delegate = self
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return .failure(.notSupported)
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        view.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        return .success(true)
    }
}

// MARK: - SceneKit sync with AR
extension ARConfigurator: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        print("The anchor has been added to AR session. The SceneKit node could be configured.")
        return viewModel.sceneKitNode(for: renderer, anchor: anchor)
    }
}
