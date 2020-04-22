//
//  AlertHelperProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Describes a behaviour of alert helper
protocol AlertHelperProtocol {
    
    /// Shows a classic alert view with OK button
    /// - Parameters:
    ///   - title: Title in the header of alert view
    ///   - message: Message to user
    ///   - viewControllerToShowIn: View controller is required to show the alert view
    func showAlert(title: String, message: String, showIn: UIViewController?)
    
    /// Automatically handles a error and show details on the specific view controller
    /// - Parameters:
    ///   - title: Title 
    ///   - error: Error
    ///   - viewControllerToShowIn: View layer
    func showAlert(title: String?, error: Error, showIn: UIViewController?)
}

