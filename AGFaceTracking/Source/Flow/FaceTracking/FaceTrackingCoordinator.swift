//
//  FaceTrackingCoordinator.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Coordinator that shows how to navigate to face tracking screen
struct FaceTrackingCoordinator: FaceTrackingCoordinatorProtocol {
    
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController, childCoordinator: [CoordinatorProtocol]? = nil) {
        
        self.navigationController = navigationController
    }
    
    func start() {
        
        let fetchModes = FetchModes()
        let processScene = ProcessScene()
        let configureSession = ConfigureSession()
        
        let viewModel = FaceTrackingViewModel(coordinator: self, useCases:[fetchModes, processScene, configureSession])
        let view = FaceTrackingViewController(viewModel: viewModel)

        DispatchQueue.main.async {
            self.navigationController.pushViewController(view, animated: true)
        }
    }
}
