//
//  ModeCellViewModel.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-22.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation

/// View model type responsible for UI state updates on face tracking mode cell
struct ModeCellViewModel: ModeCellViewModelProtocol {
    
    var mode: FaceTrackingMode?
    
    func selected() -> ModeCellViewModelProtocol {
        mode?.isSelected = true
        return self
    }
    
    func unselected() -> ModeCellViewModelProtocol {
        mode?.isSelected = false
        return self
    }
}
