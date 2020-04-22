//
//  ModeCellViewModelProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-22.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation

/// Delivers functions to setup the state of face tracking mode cell view
protocol ModeCellViewModelProtocol: ViewModelProtocol {
    
    /// Face tracking mode
    var mode: FaceTrackingMode? { get }
    
    /// Returns selected mode version contained in the View Model
    func selected() -> ModeCellViewModelProtocol
    
    /// Returns unselected mode version contained in the View Model
    func unselected() -> ModeCellViewModelProtocol
}
