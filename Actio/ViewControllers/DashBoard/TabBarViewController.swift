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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
