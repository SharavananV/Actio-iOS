//
//  ImageZoomViewController.swift
//  Actio
//
//  Created by senthil on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ImageZoomViewController: UIViewController {

	private lazy var zoomImageView: ZoomImageView = {
		let view = ZoomImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	var imageUrl: URL? {
		didSet {
			guard let url = self.imageUrl else { return }
			
			ImageLoader.shared.loadImage(from: url, true, completion: { [weak self] (image) in
				self?.zoomImageView.image = image
			})
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.addSubview(zoomImageView)
		
		zoomImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		zoomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		zoomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		zoomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
		view.backgroundColor = .white
    }
}
