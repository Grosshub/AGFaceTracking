//
//  ConfigureSessionProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit
import Combine

/// Defines a behaviour for configuring AR session use case
protocol ConfigureSessionProtocol: UseCaseProtocol {
    
    /// Setups AR session with SceneKit renderer
    /// - Parameter view: SceneKit renderer
    func apply(to view: ARSCNView) -> AnyPublisher<Bool, ARConfiguratorError>
}
