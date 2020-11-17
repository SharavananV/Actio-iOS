//
//  ErrorMessageViewController.swift
//  Actio
//
//  Created by KnilaDev on 09/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ErrorMessageViewController: UIViewController {

	var message, imageName: String?
	
	private lazy var label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = message?.uppercased()
		label.textAlignment = .center
		label.font = AppFont.PoppinsRegular(size: 18)
		label.numberOfLines = 0
		
		view.addSubview(label)
		
		return label
	}()
	
	private lazy var  imageView: UIImageView? = {
		guard let imageName = imageName, let image = UIImage(named: imageName) else {
			return nil
		}
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(imageView)
		
		return imageView
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		var constraints = [
			imageView?.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView?.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView?.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		]
		
		if let imageView = imageView {
			constraints += [
				imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2.0/3.0),
				label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
			]
		} else {
			constraints += [
				label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			]
		}
		
		NSLayoutConstraint.activate(constraints.compactMap({ $0 }))
		
		self.view.backgroundColor = .white
    }
	
	init(message: String? = nil, imageName: String? = nil) {
		super.init(nibName: nil, bundle: nil)
		
		self.message = message
		self.imageName = imageName
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}
