//
//  RedirectContainerViewController.swift
//  Actio
//
//  Created by senthil on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class RedirectContainerViewController: UINavigationController {

	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		
		rootViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
		rootViewController.navigationItem.rightBarButtonItem?.tintColor = .white
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func cancelTapped() {
		self.dismiss(animated: true, completion: nil)
	}

}
