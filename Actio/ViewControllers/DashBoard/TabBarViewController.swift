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
    }
}
