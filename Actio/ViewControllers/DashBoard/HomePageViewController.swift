//
//  HomePageViewController.swift
//  Actio
//
//  Created by senthil on 14/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import SideMenu

class HomePageViewController: UIViewController, LogoutDelegate {
    
    @IBOutlet var homeCollectionView: UICollectionView!
	private let service = DependencyProvider.shared.networkService
    var dashboardModules: [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu-white"), style: .plain, target: self, action: #selector(self.handleMenuToggle))
        self.navigationItem.leftBarButtonItem  = menuButton
		let notificationButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(self.openNotificationPage))
		self.navigationItem.rightBarButtonItem  = notificationButton
		
		self.title = "Actio Sport"
		
		changeNavigationBar()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if dashboardModules.isEmpty {
			dashboardApiCall()
		}
	}
    
    @objc func handleMenuToggle() {
        if let menuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
            menuController.delegate = self
            
            let menu = SideMenuNavigationController(rootViewController: menuController)
            menu.leftSide = true
            menu.menuWidth = UIScreen.main.bounds.size.width - 80
            menu.statusBarEndAlpha = 0
            menu.isNavigationBarHidden = true
            present(menu, animated: true, completion: nil)
        }
    }
	
	@objc func openNotificationPage() {
		let notificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
		let navigationController = UINavigationController(rootViewController: notificationVC)
		
		navigationController.modalPresentationStyle = .fullScreen
		present(navigationController, animated: true, completion: nil)
	}
    
    func presentLogin() {
        self.dismiss(animated: true) {
            if let topController = UIApplication.shared.keyWindow()?.topViewController() {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
                controller.modalPresentationStyle = .fullScreen
                topController.present(controller, animated: false, completion: nil)
            }
        }
    }
    
	func dashboardApiCall() {
		service.post(dashboardUrl, parameters: nil, onView: view) { (response) in
			if let dashboardModules = response["modules"] as? [[String : Any]] {
				self.dashboardModules = dashboardModules
			}
			
			self.homeCollectionView.reloadData()
		}
	}
}

extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardModules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HomePageCollectionViewCell", for: indexPath) as? HomePageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.homeBackgroundImageView.layer.cornerRadius = 5.0
        cell.homeBackgroundImageView.clipsToBounds = true
        
        if dashboardModules.count > 0 {
            let eachCellList = dashboardModules[indexPath.row]
            cell.homeCellLabel.text = (eachCellList["name"] as? String) ?? ""
            
            if let imageUrl = eachCellList["image"] as? String, let imagePath = URL(string:  baseImageUrl + imageUrl) {
                print(imagePath)
                cell.homeBackgroundImageView.load(url: imagePath)
            }
            
            if let iconUrl = eachCellList["icon"] as? String, let iconPath = URL(string:  baseImageUrl + iconUrl) {
                cell.homeCellImage.load(url: iconPath)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width / 2) - 5), height: CGFloat(170))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			if let nav = storyboard?.instantiateViewController(withIdentifier: "TournamentListViewController") as? TournamentListViewController {
				self.navigationController?.pushViewController(nav, animated: false)
			}
			
		case 1:
			if let nav = UIStoryboard(name: "Social", bundle: nil).instantiateViewController(withIdentifier: "ChatHistoryViewController") as? ChatHistoryViewController {
				self.navigationController?.pushViewController(nav, animated: false)
			}
			
		case 2:
			if let nav = UIStoryboard(name: "Social", bundle: nil).instantiateViewController(withIdentifier: "FriendListViewController") as? FriendListViewController {
				self.navigationController?.pushViewController(nav, animated: false)
			}
			
		default:
			view.makeToast("Coming soon")
		}
    }
}
