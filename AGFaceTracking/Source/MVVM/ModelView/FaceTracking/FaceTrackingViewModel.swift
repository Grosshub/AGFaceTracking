//
//  FaceTrackingViewModel.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation
import ARKit
import Combine

/// View model type responsible for data binding and updating view state on face tracking screen
final class FaceTrackingViewModel: FaceTrackingViewModelProtocol {
    
    @Published var modes: [FaceTrackingMode]? = []
    
    var coordinator: CoordinatorProtocol
    
    // Use cases
    var configureSession: ConfigureSessionProtocol?
    var processScene: ProcessSceneProtocol?
    private var fetchModes: FetchModesProtocol?
    
    lazy var modeCellViewModels: [ModeCellViewModelProtocol] = []
    
    init(coordinator: CoordinatorProtocol, useCases: [UseCaseProtocol]) {
        
        self.coordinator = coordinator
        
        for useCase in useCases {

            switch useCase {
            case (let useCase as FetchModesProtocol):
                fetchModes = useCase
                
            case (let useCase as ProcessSceneProtocol):
                processScene = useCase
                
            case (let useCase as ConfigureSessionProtocol):
                configureSession = useCase
                
            default:
                print("Use Case is not specified")
            }
        }
    }
    
    func fetchData() {

        fetchModes?.all().sink { newValue in
            self.modes = newValue

            guard let modes = self.modes else { return }
            for (index, mode) in modes.enumerated() {
                
                if index == 0 { mode.isSelected = true }
                mode.index = index
                self.modeCellViewModels.append(ModeCellViewModel(mode: mode))
            }
        }.cancel()
    }
    
    func viewModelForCell(at index: Int) -> ModeCellViewModelProtocol {
        return modeCellViewModels[index]
    }
    
    func currentFaceTrackingMode() -> FaceTrackingMode? {
        let mode = modes?.filter{ $0.isSelected == true }.first
        return mode
    }
}
