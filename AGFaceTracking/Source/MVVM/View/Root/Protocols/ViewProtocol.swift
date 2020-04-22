//
//  ViewProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Root protocol for view
/// All view controllers should adopt this
protocol ViewProtocol: class {
    
    /// Initialize the type with a view model responsible for data binding
    /// - Parameter viewModel: View model
    init(viewModel: ViewModelProtocol)
    
    /// Binds view model to the view
    /// View retains a reference to a view model (not vice versa)
    /// - Parameter viewModel: View Model
    func bind(viewModel: ViewModelProtocol)
}
