//
//  FaceTrackingView.swift
//  FaceTrackingTest
//
//  Created by Alexey Gross on 2020-04-18.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit
import ARKit
import MetalKit
import Metal

/// UIKit view representation of the face tracking screen
class FaceTrackingView: UIView {
    
    var sceneView: ARSCNView!
    var metalSceneView: MetalScenePreview!
    var modesView: FaceTrackingModesView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sceneView = ARSCNView()
        sceneView.isHidden = true
        addSubview(sceneView)
        
        metalSceneView = MetalScenePreview(frame: .zero, device: nil)
        metalSceneView.enableSetNeedsDisplay = false
        metalSceneView.isPaused = true
        metalSceneView.isHidden = true
        addSubview(metalSceneView)
        
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
        
        metalSceneView.frame = sceneView.frame
        
        modesView.frame = CGRect(x: 0.0,
                                 y: sceneView.frame.origin.y + sceneView.frame.size.height,
                                 width: frame.size.width,
                                 height: FaceTrackingModesSizing.height)
    }
}
