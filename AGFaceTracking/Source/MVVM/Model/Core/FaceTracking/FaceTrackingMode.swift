//
//  FaceTrackingMode.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Available face tracking mode
class FaceTrackingMode {
    
    @Published var isSelected: Bool = false
    
    let name: String
    let type: FaceTrackingModeType
    var icon: UIImage?
    var index: Int?
    var renderer: RendererType
    var greenScreenImage: CIImage?
    
    init(name: String, type: FaceTrackingModeType, icon: UIImage? = nil, indexPath: IndexPath? = nil) {
        
        self.name = name
        self.type = type
        
        switch type {
        case .noEffect:
            self.icon = UIImage(named: "mode_none")
            renderer = .sceneKit
        case .put3DmodelOnFace:
            self.icon = UIImage(named: "mode_1")
            renderer = .sceneKit
        case .put2DMaskOnFace:
            self.icon = UIImage(named: "mode_2")
            renderer = .sceneKit
        case .animateWithBlendShapes:
            self.icon = UIImage(named: "mode_3")
            renderer = .sceneKit
        case .removeBackground:
            self.icon = UIImage(named: "mode_remove_background")
            renderer = .metalKit
        case .pictureBackground:
            self.icon = UIImage(named: "mode_picture_background")
            renderer = .metalKit
            
            let image = UIImage(named: "backgroundVertical")
            if let cgImage = image?.cgImage {
                
                let ciImage = CIImage(cgImage: cgImage)
                let rotatedImage = ciImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.left.rawValue))
                greenScreenImage = rotatedImage
            }
        }
    }
}
