//
//  ProcessSceneProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit
import Combine

/// Processes SceneKit renderer with a specific anchor/node
protocol ProcessSceneProtocol: UseCaseProtocol {
    
    /// Returns a SceneKit node for specific anchor via Combine publisher
    /// Use this function to handle face tracking mode
    /// - Parameters:
    ///   - renderer: SceneKit renderer
    ///   - anchor: Face anchor
    ///   - mode: Specific face tracking mode
    func sceneKitNode(for renderer: SCNSceneRenderer, anchor: ARAnchor, mode: FaceTrackingMode?) -> AnyPublisher<SCNNode?, ARConfiguratorError>
    
    /// Animates a character with blend shapes
    /// - Parameters:
    ///   - renderer: SceneKit renderer
    ///   - anchor: Face anchor
    ///   - mode: Specific face tracking mode
    ///   - updatedNode: Node that could be already added on the scene
    func animateBlendShapes(for renderer: SCNSceneRenderer, anchor: ARAnchor, mode: FaceTrackingMode?, updatedNode: SCNNode?) -> AnyPublisher<Bool, ARConfiguratorError>
}
