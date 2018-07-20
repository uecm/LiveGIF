//
//  PhotoConvertingManager.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/20/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import Photos

protocol PhotoConverterViewing {
    var livePhotoContainerSize: CGSize { get }
    var livePhotoContentMode: PHImageContentMode { get }
}


final class PhotoConvertingManager {
    
    var assets: [PHAsset]?
    
    var viewer: PhotoConverterViewing!
    
    var asset: PHAsset? {
        get { return assets?.first }
        set { assets = newValue.map { [$0] } }
    }
    
    
    func fetchLivePhoto(completion: @escaping (PHLivePhoto?) -> Void) {
        guard let asset = asset else { return completion(nil) }
        
        PHImageManager.default().requestLivePhoto(
            for: asset,
            targetSize: viewer.livePhotoContainerSize,
            contentMode: viewer.livePhotoContentMode,
            options: nil) { (photo, _) in
                completion(photo)
        }
    }
    
}
