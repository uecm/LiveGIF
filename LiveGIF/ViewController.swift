//
//  ViewController.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var photoPicker: PhotoPicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func openPicker(_ sender: Any) {
  
        let picker = LivePhotoPicker()
        self.photoPicker = picker
        
        picker.show(in: self, completion: nil)
        
    }
    
    
}

extension ViewController: PhotoPickerDelegate {
    
}

