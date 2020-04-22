//
//  FaceTrackingModesView.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

/// Views that represents the face tracking modes selection view
class FaceTrackingModesView: UIView {
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = FaceTrackingModesViewSizes.collectionItemSize
        collectionViewLayout.sectionInset = FaceTrackingModesViewSizes.collectionSectionInset
        collectionViewLayout.minimumLineSpacing = 0.0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension FaceTrackingModesView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = CGRect(x: 0.0,
                                      y: frame.size.height - FaceTrackingModesViewSizes.collectionViewSize.height,
                                      width: frame.size.width,
                                      height: FaceTrackingModesViewSizes.collectionViewSize.height)
    }
}

// MARK: - Fixed sizes for tracking modes view
private struct FaceTrackingModesViewSizes {
    
    static let collectionViewSize = CGSize(width: UIScreen.main.bounds.width, height: FaceTrackingModesSizing.height)
    static let collectionSectionInset = UIEdgeInsets(top: 0.0, left: 41.5, bottom: 0.0, right: 41.5)
    static let collectionItemSize = CGSize(width: 100.0, height: FaceTrackingModesSizing.height)
}
