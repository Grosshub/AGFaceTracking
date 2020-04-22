//
//  ARConfiguratorProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit

/// Describes behaviour of ARConfigurator
protocol ARConfiguratorProtocol: class, ViewModelDependencyProtocol {
    
    /// Setups AR session with SceneKit renderer
    /// - Parameter view: SceneKit renderer
    func setupARSession(for view: ARSCNView) -> Result<Bool, ARConfiguratorError>
}
