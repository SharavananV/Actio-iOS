//
//  ProfilePageViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import SideMenu

class ProfilePageViewController: UIViewController, LogoutDelegate {
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet var profileEmailLabel: UILabel!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet weak var profileFriendsListCollectionView: UICollectionView!
	@IBOutlet var actioEventsCollectionView: UICollectionView!
	private let service = DependencyProvider.shared.networkService
    var friendsListModel : [Friend]?
	var eventsAssociated: [EventAssociated]?
	var userDetails: Friend?
    var userName: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        profileBackgroundView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
		
        profileFriendsListCollectionView.delegate = self
        profileFriendsListCollectionView.dataSource = self
		
		let menuButton = UIBarButtonItem(image: UIImage(named: "menu-white"), style: .plain, target: self, action: #selector(self.handleMenuToggle))
		self.navigationItem.leftBarButtonItem  = menuButton
		let notificationButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(self.openNotificationPage))
		self.navigationItem.rightBarButtonItem  = notificationButton
		
		self.title = "Actio Sport"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		myProfileCall()
		
		self.profileImageView.layer.cornerRadius = UIScreen.main.bounds.width * 0.165
		self.profileImageView.clipsToBounds = true
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
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        if let nav = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            nav.userDetails = self.userDetails
            self.navigationController?.pushViewController(nav, animated: true)
        }
    }
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        if let nav = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
            nav.userName = self.userName
            self.navigationController?.pushViewController(nav, animated: true)
        }
    }
	
	@IBAction func performanceReviewAction(_ sender: Any) {
		let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "PerformanceReviewListViewController")
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func addNonActioEvents(_ sender: Any) {
		let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "NonActioSportViewController")
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
    func myProfileCall() {
		service.post(myProfileUrl, parameters: nil, onView: view) { [self] (response: MyProfileResponse) in
            self.userDetails = response.profile?.profile
            self.profileEmailLabel.text = self.userDetails?.emailID
            self.profileNameLabel.text = self.userDetails?.fullName
			if let profileImage = self.userDetails?.profileImage, let url = URL(string: baseImageUrl + profileImage) {
				self.profileImageView.load(url: url)
			}
            self.userName = self.userDetails?.username
            self.friendsListModel = response.profile?.list
			self.eventsAssociated = response.eventAssociated
            self.profileFriendsListCollectionView.reloadData()
			self.actioEventsCollectionView.reloadData()
        }
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
}
extension ProfilePageViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.actioEventsCollectionView {
			return self.eventsAssociated?.count ?? 0
		}
        return self.friendsListModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == self.actioEventsCollectionView {
			guard let eventsCell = collectionView.dequeueReusableCell(withReuseIdentifier:"EventsAssociatedCollectionViewCell", for: indexPath) as? EventsAssociatedCollectionViewCell else {
				return UICollectionViewCell()
			}
			guard let associatedList = self.eventsAssociated?[indexPath.row] else {
				return UICollectionViewCell()
			}
			if let eventsProfileImage = associatedList.eventLogo,let imagePath = URL(string:  baseImageUrl + eventsProfileImage) {
				eventsCell.associatedImageView.load(url: imagePath)
			}
			eventsCell.associatedEventsName.text = associatedList.eventName
			eventsCell.associatedLocationLabel.text = associatedList.eventAddress
			eventsCell.setDateText(associatedList.eventStartDate ?? "", month: associatedList.eventStartMonth ?? "", year: associatedList.eventStartYear ?? "")
			
			return eventsCell
		} else {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ProfileFriendsListCollectionViewCell", for: indexPath) as? ProfileFriendsListCollectionViewCell else {
				return UICollectionViewCell()
			}
			guard let friendsList = self.friendsListModel?[indexPath.row] else {
				return UICollectionViewCell()
			}
			if let profileImage = friendsList.profileImage,let imagePath = URL(string:  baseImageUrl + profileImage) {
				cell.friendsProfileImageView.load(url: imagePath)
			}
			cell.friendsProfileImageView.layer.cornerRadius = cell.friendsProfileImageView.frame.height/2
			cell.friendsProfileImageView.clipsToBounds = true
			cell.friendsNameLabel.text = friendsList.fullName
			return cell
		}
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == profileFriendsListCollectionView {
			let friendsList = self.friendsListModel?[indexPath.row]
			if let nav = storyboard?.instantiateViewController(withIdentifier: "FriendsProfilePageViewController") as? FriendsProfilePageViewController {
				nav.friendId = friendsList?.subscriberID
				self.navigationController?.pushViewController(nav, animated: true)
			}
		} else {
			if let associatedList = self.eventsAssociated?[indexPath.item], let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "ActioEventKPIViewController") as? ActioEventKPIViewController {
				vc.eventId = associatedList.id
				
				self.navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
}
