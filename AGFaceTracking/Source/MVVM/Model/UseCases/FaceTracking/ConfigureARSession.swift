//
//  ConfigureARSession.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import ARKit
import Combine

/// Use case responsible for AR session configuration
class ConfigureARSession: ConfigureARSessionProtocol {
    
    var isConfigured: Bool = false
    
    private var renderingEnabled: Bool = false
    
    func apply(to view: ARSCNView, renderingEnabled: Bool) -> AnyPublisher<Bool, ARConfiguratorError> {

        DispatchQueue.main.async {
            view.isHidden = !renderingEnabled
        }
        
        if !renderingEnabled {
            isConfigured = false
            view.session.pause()
            return CurrentValueSubject(isConfigured).eraseToAnyPublisher()
        
        }
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return Fail(error: .notSupported).eraseToAnyPublisher()
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        view.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        isConfigured = true
        return CurrentValueSubject(isConfigured).eraseToAnyPublisher()
    }
}
