//
//  AssetCell.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit

final class AssetCell: UICollectionViewCell {
    
    static let identifier = "assetCell"
    
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImageView.image = nil
        checkmark.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        checkmark.layer.cornerRadius = checkmark.bounds.height / 2
        checkmark.layer.masksToBounds = true
    }
    
    
    func setup(with image: UIImage?, selected: Bool) {
        previewImageView.image = image
        setSelected(selected)
    }
    
    func setSelected(_ selected: Bool) {
        checkmark.isHidden = !selected
    }
    
}
