//
//  MenuViewController.swift
//  Actio
//
//  Created by apple on 16/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol LogoutDelegate: class {
    func presentLogin()
}

class MenuViewController: UIViewController {
    let dependencyProvider = DependencyProvider.shared
    weak var delegate: LogoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))
        view.backgroundColor = AppColor.OrangeColor()
        self.view.addSubview(view)
    }
    

    @IBAction func logoutAction(_ sender: Any) {
        ActioSpinner.shared.show(on: self.view)
        
        self.dependencyProvider.registerDatasource.logout { (message) in
            self.view.makeToast(message)
            ActioSpinner.shared.hide()
            
            if message == "Logout Success" {
                self.delegate?.presentLogin()
            }
        }
    }

}
