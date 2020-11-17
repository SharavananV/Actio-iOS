//
//  ImagePreviewViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    @IBOutlet var previewImage: UIImageView!
    var previewUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = self.previewUrl {
            self.previewImage.load(url: url)
        }
    }
    

}
