//
//  ErrorHelper.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation

/// Error helper operates with custom errors and provide the string messages back to responder
struct ErrorHelper: ErrorHelperProtocol {
    
    func handleCommonError(error: Error) -> String {
        
        if let error = error as? ARConfiguratorError {
            return handleError(error: error)
        }
        
        return error.localizedDescription
    }
    
    func handleError(error: ARConfiguratorError) -> String {
        
        switch error {
        case .notSupported:
            return "There is no camera session configuration without camera device access"
        case .wrongRenderer:
            return "Renderer cannot process changes"
        case .wrongAnchor:
            return "Wrong anchor type"
        case .unknown:
            return "Unknown error"
        }
    }
}
