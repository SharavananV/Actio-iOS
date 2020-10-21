//
//  EditProfileViewController.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    enum TabIndex : Int {
        case infoTab = 0
        case myRoleTab = 1
    }
    
    @IBOutlet weak var profileSegmentControl: UISegmentedControl!
    @IBOutlet weak var editProfileImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    var currentViewController: UIViewController?
    
    lazy var infoTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController")
        return firstChildTabVC
    }()
    lazy var myRoleTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "MyRoleViewController")
        
        return secondChildTabVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileSegmentControl.selectedSegmentIndex = TabIndex.infoTab.rawValue
        displayCurrentTab(TabIndex.infoTab.rawValue)


    }
    
    @IBAction func segementedControlAction(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)

    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.infoTab.rawValue :
            vc = infoTabVC
        case TabIndex.myRoleTab.rawValue :
            vc = myRoleTabVC
        default:
            return nil
        }
        
        return vc
    }


}
