//
//  ConvertingViewController.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/20/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit
import PhotosUI

final class ConvertingViewController: UIViewController {
    class var identifier: String { return "\(self)" }

    @IBOutlet weak var photoView: PHLivePhotoView!
    
    lazy var manager = PhotoConvertingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.viewer = self
    
        manager.fetchLivePhoto { [weak self] (photo) in
            self?.photoView.livePhoto = photo
            self?.photoView.startPlayback(with: PHLivePhotoViewPlaybackStyle.full)
        }
    }
}

extension ConvertingViewController: PhotoConverterViewing {
    var livePhotoContainerSize: CGSize {
        return photoView.frame.size
    }
    
    var livePhotoContentMode: PHImageContentMode {
        return .default
    }
}
