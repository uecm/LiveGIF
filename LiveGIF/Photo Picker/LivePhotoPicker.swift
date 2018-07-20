//
//  LivePhotoPicker.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import Photos
import UIKit

final class LivePhotoPicker: PhotoPicker {
    
    var allowsMultipleSelection: Bool = true

    var convertsToImage: Bool = false
    
    private var presenter: PhotoPickerPresenter?
    
    private var livePhotoAssets: [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaSubtype == %ld", PHAssetMediaSubtype.photoLive.rawValue)
        var assets: [PHAsset] = []
        
        PHAsset.fetchAssets(with: fetchOptions).enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        
        return assets
    }
}

extension LivePhotoPicker {

    var delegate: PhotoPickerDelegate? {
        return presenter
    }
    
    var photoPickerView: PhotoPickerViewing? {
        return PhotoPickerView.instantiate() as? PhotoPickerViewing
    }
    
    func show(in presenter: PhotoPickerPresenter, completion: Callback?) {
        guard let viewer = photoPickerView else { return }
        
        let navigationController = UINavigationController(rootViewController: viewer.viewController)
        presenter.present(navigationController, animated: true, completion: completion)
        
        viewer.delegate = self
        viewer.allowsMultipleSelection = allowsMultipleSelection
        
        viewer.showAssets(livePhotoAssets)
        
        self.presenter = presenter
    }
    
    func dismiss(completion: Callback? = nil) {
        presenter?.dismiss(animated: true, completion: completion)
    }
}

extension LivePhotoPicker: PhotoPickerViewingDelegate {
    
    func photoPickerView(_ view: PhotoPickerViewing, didSelect assets: [PHAsset]) {
        
        var images: [UIImage?] = []
        
        guard convertsToImage else {
            return delegate?.photoPicker(self, didSelect: assets) ?? ()
        }
        
        assets.forEach {
            PHImageManager.default().requestImage(
                for: $0,
                targetSize: .init(width: $0.pixelWidth, height: $0.pixelHeight),
                contentMode: .default,
                options: nil,
                resultHandler: { (image, _) in
                    images.append(image)
            })
        }
        
        delegate?.photoPicker(self, didSelect: images.compactMap { $0 })
    }
    
    func photoPickerViewDidDismiss(_ view: PhotoPickerViewing) {
        
    }
}
