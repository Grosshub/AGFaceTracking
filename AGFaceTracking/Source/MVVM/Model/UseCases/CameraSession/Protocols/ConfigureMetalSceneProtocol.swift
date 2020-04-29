//
//  ConfigureMetalSceneProtocol.swift
//  AGFaceTrackingApp
//
//  Created by Alexey Gross on 2020-04-29.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Combine
import MetalKit

/// Configures a session for a metal scene to start live translation from a camera
protocol ConfigureMetalSceneProtocol: UseCaseProtocol {
    
    /// Detects if metal scene session is already configured
    var isConfigured: Bool { get }
    
    /// Configures a renderer
    /// - Parameter metalScene: Metal scene
    ///   - renderingEnabled: Is rendering enabled?
    func configureMetalScene(metalScene: MetalScenePreviewProtocol, greenScreenImage: CIImage?, renderingEnabled: Bool) -> AnyPublisher<Bool, MetalSessionError> 
}
