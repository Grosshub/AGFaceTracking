//
//  SCNReferenceNode+Extension.swift
//  FaceTrackingTest
//
//  Created by Alexey Gross on 2020-04-18.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import SceneKit

/// Extension that is used for convenient way to load a model file from app bundle
extension SCNReferenceNode {
    
    convenience init(named resourceName: String, loadImmediately: Bool = true) {
        
        let url = Bundle.main.url(forResource: resourceName, withExtension: "scn", subdirectory: "Models.scnassets")!
        
        self.init(url: url)!
        
        if loadImmediately {
            self.load()
        }
    }
}
