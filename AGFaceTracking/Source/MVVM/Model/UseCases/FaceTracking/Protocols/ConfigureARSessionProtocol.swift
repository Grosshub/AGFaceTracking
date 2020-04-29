//
//  ConfigureARSessionProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit
import Combine

/// Defines a behaviour for configuring AR session use case
protocol ConfigureARSessionProtocol: UseCaseProtocol {
    
    /// Let us check the current session state
    var isConfigured: Bool { get }
    
    /// Setups AR session with SceneKit renderer
    /// - Parameter view: SceneKit renderer
    ///   - renderingEnabled: Is rendering enabled?
    func apply(to view: ARSCNView, renderingEnabled: Bool) -> AnyPublisher<Bool, ARConfiguratorError>
}
