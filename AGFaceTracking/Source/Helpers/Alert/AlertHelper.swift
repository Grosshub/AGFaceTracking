//
//  AlertHelper.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Respond for all alert view presentation in the app
struct AlertHelper: AlertHelperProtocol {
    
    func showAlert(title: String, message: String, showIn: UIViewController?) {
        
        DispatchQueue.main.async {

            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            if let showIn = showIn {
                showIn.present(alert, animated: true)
            }
        }
    }
    
    func showAlert(title: String? = nil, error: Error, showIn: UIViewController?) {

        let errorHelper = ErrorHelper()
        let message = errorHelper.handleCommonError(error: error)
        
        DispatchQueue.main.async {

            let alert = UIAlertController(title: title ?? "Error",
                                          message: message,
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            if let showIn = showIn {
                showIn.present(alert, animated: true)
            }
        }
    }
}
