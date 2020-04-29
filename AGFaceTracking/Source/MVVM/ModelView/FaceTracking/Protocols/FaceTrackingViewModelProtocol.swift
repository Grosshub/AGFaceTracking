//
//  FaceTrackingViewModelProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation

/// Deliveres functions to setup UI state for face tracking view
protocol FaceTrackingViewModelProtocol: ViewModelProtocol {
    
    /// Returns all available modes
    var modes: [FaceTrackingMode]? { get }
    
    /// Current renderer to draw AR experience
    var currentRenderer: RendererType { get }
    
    /// Use case responsible for AR session configuration
    var configureARSession: ConfigureARSessionProtocol? { get }
    
    /// Use case responsible for SceneKit renderer 
    var processScene: ProcessSceneProtocol? { get }
    
    /// Allows to start fetching all possible data
    func fetchData()
    
    /// Returns a View Model for a specific cell index
    /// - Parameter index: Cell index (index path row)
    func viewModelForCell(at index: Int) -> ModeCellViewModelProtocol
    
    /// Returns a current face tracking mode
    func currentFaceTrackingMode() -> FaceTrackingMode?
}
