//
//  ErrorHelperProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation

/// Describes logic which helps to handle customs errors
protocol ErrorHelperProtocol {
    
    /// Handles common error
    /// - Parameter error: Error
    func handleCommonError(error: Error) -> String
    
    /// Handles a AR configurator error  and return a message in string format
    /// - Parameter error: Error
    func handleError(error: ARConfiguratorError) -> String
}
