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
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImageView.image = nil
    }
    
    
    func setImage(_ image: UIImage?) {
        previewImageView.image = image
    }
    
}
