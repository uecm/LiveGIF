//
//  PhotoPicker.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit
import Photos

// UIViewController that presents Photo Picker
typealias PhotoPickerPresenter = UIViewController & PhotoPickerDelegate


// Mediator between UIViewController and PhotoPickerView
protocol PhotoPicker: AnyObject {
    var delegate: PhotoPickerDelegate? { get }
    
    var photoPickerView: PhotoPickerViewing? { get }
    
    func show(in presenter: PhotoPickerPresenter, completion: Callback?)
    func dismiss(completion: Callback?)
}

// Notify Presenter about actions from Photo Picker
protocol PhotoPickerDelegate {
    
}


// Photo Picker Viewer
protocol PhotoPickerViewing: AnyObject {
    
    static func instantiate() -> UIViewController
    
    var viewController: UIViewController { get }
    
    var delegate: PhotoPickerViewingDelegate? { get set }
    
    func showAssets(_ assets: [PHAsset]?)
}

protocol PhotoPickerViewingDelegate: AnyObject {
    func photoPickerView(_ view: PhotoPickerViewing, didSelect assets: [PHAsset])
    func photoPickerViewDidDismiss(_ view: PhotoPickerViewing)
}



