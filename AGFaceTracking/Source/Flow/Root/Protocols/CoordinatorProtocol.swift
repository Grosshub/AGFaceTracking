//
//  CoordinatorProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Root protocol for coordinators
///
/// + Each Coordinator should adopt this
protocol CoordinatorProtocol {
    
    /// Each coordinator owns a root controller to navigate between screens
    var navigationController: UINavigationController { get set }
    
    /// Child coordinators that stored in another coordinator
    var childCoordinators: [CoordinatorProtocol] { get }
    
    /// Start coordinator's screen presentation
    func start()
}
