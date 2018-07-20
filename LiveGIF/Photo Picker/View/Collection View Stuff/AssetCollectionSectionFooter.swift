//
//  AssetCollectionSectionFooter.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/17/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit

final class AssetCollectionSectionFooter: UICollectionReusableView {
    
    class var nib: UINib {
        return .init(nibName: "AssetCollectionSectionFooter", bundle: nil)
    }
    
    @IBOutlet weak var photoCountLabel: UILabel!
    
    func setup(photoCount: Int) {
        let photoCountText = String(format:
            NSLocalizedString("%@ Photos", comment: "Number of photos in section"),
            formattedNumber(photoCount)
        )
        photoCountLabel.text = photoCountText
    }
    
    private func formattedNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = formatter.locale.groupingSeparator
        return formatter.string(from: NSNumber(value: number)) ?? String(number)
    }
    
}
