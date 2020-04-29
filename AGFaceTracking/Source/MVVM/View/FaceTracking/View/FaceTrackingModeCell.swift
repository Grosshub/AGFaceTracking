//
//  FaceTrackingModeCell.swift
//  FaceTrackingAppApp
//
//  Created by Alexey Gross on 2020-04-19.
//  Copyright © 2020 Alexey Gross. All rights reserved.
//

import UIKit

class FaceTrackingModeCell: UICollectionViewCell {
    
    var viewModel: ModeCellViewModelProtocol?
    var preview: UIImageView!
    var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        preview = UIImageView(frame: .zero)
        preview.layer.shouldRasterize = true
        preview.layer.shadowOffset = .zero
        preview.layer.shadowColor = UIColor.cyan.cgColor
        preview.layer.shadowRadius = 30
        addSubview(preview)
        
        nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.layer.shadowOffset = .zero
        nameLabel.layer.shadowColor = UIColor.cyan.cgColor
        nameLabel.layer.shadowRadius = 10
        nameLabel.font = UIFont(name: "AvenirNext-Regular", size: 13.0)
        nameLabel.numberOfLines = 0
        addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Update
extension FaceTrackingModeCell {
    
    func update(with viewModel: ModeCellViewModelProtocol) {
        
        self.viewModel = viewModel
        
        nameLabel.text = viewModel.mode?.name
        preview.image = viewModel.mode?.icon
        
        if viewModel.mode?.isSelected == true {
            preview.layer.shadowOpacity = 0.9
            nameLabel.layer.shadowOpacity = 0.9
            nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 13.0)
        } else {
            preview.layer.shadowOpacity = 0.0
            nameLabel.layer.shadowOpacity = 0.0
            nameLabel.font = UIFont(name: "AvenirNext-Regular", size: 13.0)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - Layout
extension FaceTrackingModeCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let previewSize = CGSize(width: preview.image?.size.width ?? 0.0, height: preview.image?.size.height ?? 0.0)
        let previewOrigin = CGPoint(x: (frame.size.width - previewSize.width) / 2, y: 35.0)
        preview.frame = CGRect(x: previewOrigin.x,
                               y: previewOrigin.y,
                               width: previewSize.width,
                               height: previewSize.height)
        
        let nameLabelOrigin = CGPoint(x: 0.0, y: preview.frame.origin.y + preview.frame.size.height + 8.0)
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: nameLabelOrigin.x,
                                 y: nameLabelOrigin.y,
                                 width: frame.size.width,
                                 height: nameLabel.frame.size.height)
    }
}
