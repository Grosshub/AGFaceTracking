//
//  StoreModes.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-21.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import Foundation
import Combine

/// Business rule responsible for storing and fetching face tracking modes
class FetchModes: FetchModesProtocol {
    
    private let faceTrackingModes: [FaceTrackingMode] = {
        
        return [FaceTrackingMode(name: "No effect", type: .noEffect),
                FaceTrackingMode(name: "3D content", type: .put3DmodelOnFace),
                FaceTrackingMode(name: "2D texture", type: .put2DMaskOnFace),
                FaceTrackingMode(name: "Blend shapes", type: .animateWithBlendShapes),
                FaceTrackingMode(name: "Remove background", type: .removeBackground),
                FaceTrackingMode(name: "Picture background", type: .pictureBackground)]
    }()
    
    func all() -> AnyPublisher<[FaceTrackingMode], Never> {
        return Just(faceTrackingModes).eraseToAnyPublisher()
    }
    
    func mode(by index: Int) -> FaceTrackingMode? {
        
        if faceTrackingModes.count <= index {
            return nil
        }
        
        let mode = faceTrackingModes[index]
        if mode.index == nil {
            mode.index = index
        }
        
        return mode
    }
}
