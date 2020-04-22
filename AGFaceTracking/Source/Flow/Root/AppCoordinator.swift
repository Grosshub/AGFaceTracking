//
//  AppCoordinator.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Root App Coordinator that handes navigation over the app
struct AppCoordinator: CoordinatorProtocol {
    
    private var window: UIWindow
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    /// Initialization
    ///
    /// - Parameter window: main backdrop for the app coordinator
    init(window: UIWindow) {
        
        navigationController = UINavigationController()
        self.window = window
        self.window.rootViewController = navigationController

        let faceTrackingCoordinator = FaceTrackingCoordinator(navigationController: navigationController)
        childCoordinators.append(faceTrackingCoordinator)
    }
    
    func start() {
        
        if !childCoordinators.isEmpty {
            
            childCoordinators.first?.start()
            window.makeKeyAndVisible()
        }
    }
}
