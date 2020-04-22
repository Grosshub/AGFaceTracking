//
//  ARConfiguratorError.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation

/// Use this to track the AR configuration error
enum ARConfiguratorError: Error {
    
    case notSupported
    case wrongRenderer
    case wrongAnchor
    case unknown
}
