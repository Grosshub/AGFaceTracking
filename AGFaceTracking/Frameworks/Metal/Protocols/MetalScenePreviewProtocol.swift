//
//  MetalScenePreviewProtocol.swift
//  AGFaceTrackingApp
//
//  Created by Alexey Gross on 2020-04-29.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit
import MetalKit

/// Describes extended properties and functions of metal scene view
protocol MetalScenePreviewProtocol: MTKView {
    
    /// Background image for metal scene
    var image: CIImage? { get set }
    
    /// Configures a metal renderer
    func configureMetal()
}
