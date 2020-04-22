//
//  FaceTrackingView.swift
//  FaceTrackingTest
//
//  Created by Alexey Gross on 2020-04-18.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit
import ARKit

/// UIKit view representation of the face tracking screen
class FaceTrackingView: UIView {
    
    var sceneView: ARSCNView!
    var modesView: FaceTrackingModesView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sceneView = ARSCNView()
        addSubview(sceneView)
        
        modesView = FaceTrackingModesView()
        addSubview(modesView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension FaceTrackingView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sceneView.frame = CGRect(x: 0.0,
                                 y: 0.0,
                                 width: frame.size.width,
                                 height: frame.size.height - FaceTrackingModesSizing.height)
        
        modesView.frame = CGRect(x: 0.0,
                                 y: sceneView.frame.origin.y + sceneView.frame.size.height,
                                 width: frame.size.width,
                                 height: FaceTrackingModesSizing.height)
    }
}
