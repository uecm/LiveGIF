//
//  LivePhotoPicker.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import Photos
import UIKit

final class LivePhotoPicker {
    
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

extension LivePhotoPicker: PhotoPicker {

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
        
        viewer.showAssets(livePhotoAssets)
        
    }
    
    func dismiss(completion: Callback?) {
        presenter?.dismiss(animated: true, completion: completion)
    }
    
}
