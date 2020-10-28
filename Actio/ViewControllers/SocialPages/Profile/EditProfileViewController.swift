//
//  EditProfileViewController.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController{
    
    enum TabIndex : Int {
        case infoTab = 0
        case myRoleTab = 1
    }
    
    @IBOutlet weak var profileSegmentControl: UISegmentedControl!
    @IBOutlet weak var editProfileImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    var currentViewController: UIViewController?
    var userDetails: Friend?
    
    lazy var MyRoleViewController : MyRoleViewController? = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyRoleViewController") as! MyRoleViewController
        return viewController
    }()
    
    private lazy var InfoViewController: InfoViewController = {
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        viewController.userDetails = self.userDetails
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        profileSegmentControl.selectedSegmentIndex = TabIndex.infoTab.rawValue
        displayCurrentTab(TabIndex.infoTab.rawValue)
        
        editProfileImage.layer.cornerRadius = editProfileImage.frame.height/2
        editProfileImage.clipsToBounds = true
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
            vc = InfoViewController
        case TabIndex.myRoleTab.rawValue :
            vc = MyRoleViewController
        default:
            return nil
        }
        
        return vc
    }


}
