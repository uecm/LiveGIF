//
//  PhotoPickerView.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit
import Photos


final class PhotoPickerView: UIViewController, PhotoPickerViewing {
    
    static func instantiate() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoPickerRoot")
    }
    
    var delegate: PhotoPickerViewingDelegate?

    var viewController: UIViewController {
        return self
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var cachingManager = PHCachingImageManager()
    
    private var assets: [PHAsset]? {
        willSet { cachingManager.stopCachingImagesForAllAssets() }
        didSet { cacheImages(for: assets) }
    }
    
    private var selectedAssets: Set<PHAsset>?
    
    func showAssets(_ assets: [PHAsset]?) {
        
        loadViewIfNeeded()
        
        self.assets = assets
        collectionView.reloadData()
    }
    
    private func cacheImages(for assets: [PHAsset]?) {
        guard let assets = assets else { return }
        cachingManager.startCachingImages(
            for: assets,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFill,
            options: nil
        )
    }
    
    @IBAction func done(_ sender: Any) {
        if let selected = selectedAssets {
            delegate?.photoPickerView(self, didSelect: Array(selected))
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.photoPickerViewDidDismiss(strongSelf)
            }
        }
    }
}


extension PhotoPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetCell.identifier, for: indexPath) as? AssetCell else {
            preconditionFailure("Could not initialize cell for displaying asset")
        }

        if cell.tag != 0 {
            cachingManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        guard let asset = assets?[indexPath.row] else {
            return cell
        }
        
        let tag = cachingManager.requestImage(
            for: asset,
            targetSize: cell.frame.size,
            contentMode: .aspectFill,
            options: nil) { (image, _) in
                cell.setImage(image)
        }
        
        cell.tag = Int(tag)
        
        return cell
    }
    
    
}


extension PhotoPickerView: UICollectionViewDelegate {
    
}
