//
//  ConfigureSession.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit
import Combine

/// Use case responsible for AR session configuration
struct ConfigureSession: ConfigureSessionProtocol {
    
    func apply(to view: ARSCNView) -> AnyPublisher<Bool, ARConfiguratorError> {
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return Fail(error: .notSupported).eraseToAnyPublisher()
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        view.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        return CurrentValueSubject(true).eraseToAnyPublisher()
    }
}
