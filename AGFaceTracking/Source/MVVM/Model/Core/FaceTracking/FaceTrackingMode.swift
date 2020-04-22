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
    
    let name: String
    let type: FaceTrackingModeType
    var icon: UIImage?
    var index: Int?
    var isSelected: Bool = false
    
    init(name: String, type: FaceTrackingModeType, icon: UIImage? = nil, indexPath: IndexPath? = nil) {
        
        self.name = name
        self.type = type
        
        switch type {
        case .none:
            self.icon = UIImage(named: "mode_none")
        case .put3DmodelOnFace:
            self.icon = UIImage(named: "mode_1")
        case .put2DMaskOnFace:
            self.icon = UIImage(named: "mode_2")
        }
    }
}
