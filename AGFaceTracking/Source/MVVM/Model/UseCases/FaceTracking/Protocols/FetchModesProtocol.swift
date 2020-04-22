//
//  FetchModesProtocol.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Combine

/// Defines use case responsible for fetching face tracking modes
protocol FetchModesProtocol: UseCaseProtocol {
    
    /// Returns all stored face tracking modes
    func all() -> AnyPublisher<[FaceTrackingMode], Never>
    
    /// Returns a face tracking mode by it's index
    /// - Parameter index: Face tracking mode
    func mode(by index: Int) -> FaceTrackingMode?
}
