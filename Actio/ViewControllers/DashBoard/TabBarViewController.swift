//
//  TabBarViewController.swift
//  Actio
//
//  Created by senthil on 15/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
		
		if let arrayOfTabBarItems = self.tabBar.items {
			for index in 0..<arrayOfTabBarItems.count {
				switch index {
				case 3, 4:
					let item = arrayOfTabBarItems[index]
					item.isEnabled = false
				default:
					break
				}
			}
		}
    }
}
