//
//  ViewController.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController {

    private var photoPicker: PhotoPicker?
    
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var assets: [PHAsset]? {
        didSet { convertButton.isEnabled = assets?.isEmpty == false }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        convertButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func openPicker(_ sender: Any) {
  
        let picker = LivePhotoPicker()
        self.photoPicker = picker
        
        picker.convertsToImage = false
        picker.allowsMultipleSelection = false
        picker.show(in: self, completion: nil)
    }
    
    @IBAction func proceedToConverting(_ sender: Any) {
         guard let convertingController = storyboard?.instantiateViewController(
            withIdentifier: ConvertingViewController.identifier
            ) as? ConvertingViewController else {
                preconditionFailure("Could not initialize converting controller")
        }
        convertingController.manager.asset = assets?.first
        show(convertingController, sender: nil)
    }
    
}

extension ViewController: PhotoPickerDelegate {
    func photoPicker(_ picker: PhotoPicker, didSelect images: [UIImage]) { }
    
    func photoPicker(_ picker: PhotoPicker, didSelect assets: [PHAsset]) {
        self.assets = assets
        if assets.count > 0 {
            statusLabel.text = "You can proceed to converting your photo to GIF now"
        }
        picker.dismiss(completion: nil)

    }
}

