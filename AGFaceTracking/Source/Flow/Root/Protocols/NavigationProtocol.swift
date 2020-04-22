//
//  NavigationProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation

/// Handles basic user navigations
/// Use this protocol in coordinators and presenters
/// This will connect view with presenter and presenter will call coordinator to make a movement
protocol NavigationProtocol {
    
    /// Notifies presenter when user wants to back to previous screen
    func backToPreviousScreen()
}
