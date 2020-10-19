//
//  FriendsProfilePageViewController.swift
//  Actio
//
//  Created by apple on 13/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class FriendsProfilePageViewController: UIViewController {
	
	@IBOutlet weak var friendsPageBackgroundView: UIView!
	@IBOutlet weak var friendsProfileImageView: UIImageView!
	@IBOutlet weak var friendsEmailLabel: UILabel!
	@IBOutlet weak var friendsProfileNameLabel: UILabel!
	@IBOutlet weak var friendsListCollectionView: UICollectionView!
    @IBOutlet weak var eventsAssociatedCollectionView: UICollectionView!
	private let service = DependencyProvider.shared.networkService
    private var friendsListModel : [List]?
    private var friendsEventsAssociated : [EventAssociated]?
    var currentFriend: Friend?

    override func viewDidLoad() {
		super.viewDidLoad()
		
		friendsPageBackgroundView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
		self.friendsProfileImageView.layer.cornerRadius = self.friendsProfileImageView.frame.height/2
		self.friendsProfileImageView.clipsToBounds = true
		self.friendsEmailLabel.text = currentFriend?.emailID
		self.friendsProfileNameLabel.text = currentFriend?.fullName
		if let image = currentFriend?.profileImage, let url = URL(string: baseImageUrl + image) {
			friendsProfileImageView.load(url: url)
		}
        friendsListCollectionView.delegate = self
        friendsListCollectionView.dataSource = self
        eventsAssociatedCollectionView.dataSource = self
        eventsAssociatedCollectionView.delegate = self

		friendsListCall()
	}
	
	func friendsListCall() {
		let parameters:[String:Any] = ["friendID": currentFriend?.subscriberID ?? 0]
		service.post(friendListUrl, parameters: parameters , onView: view) { (response: FriendsListResponse) in
            self.friendsListModel = response.list
            self.friendsEventsAssociated = response.eventAssociated
            self.friendsListCollectionView.reloadData()
            self.eventsAssociatedCollectionView.reloadData()
		}
	}
	
	@IBAction func chatAction(_ sender: Any) {
		if let vc = UIStoryboard(name: "Social", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
			vc.friendsModel = self.currentFriend
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}

extension FriendsProfilePageViewController : UICollectionViewDelegate,UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.friendsListCollectionView {
            return self.friendsListModel?.count ?? 0
            
        }
        return self.friendsEventsAssociated?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.friendsListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FriendsListCollectionViewCell", for: indexPath) as? FriendsListCollectionViewCell else {
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
        guard let eventsCell = collectionView.dequeueReusableCell(withReuseIdentifier:"EventsAssociatedCollectionViewCell", for: indexPath) as? EventsAssociatedCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let associatedList = self.friendsEventsAssociated?[indexPath.row] else {
            return UICollectionViewCell()
        }
        if let eventsProfileImage = associatedList.eventLogo,let imagePath = URL(string:  baseImageUrl + eventsProfileImage) {
            eventsCell.associatedImageView.load(url: imagePath)
        }
        eventsCell.associatedEventsName.text = associatedList.eventName
        eventsCell.associatedLocationLabel.text = associatedList.eventAddress
        eventsCell.setDateText(associatedList.eventStartDate ?? "", month: associatedList.eventStartMonth ?? "", year: associatedList.eventStartYear ?? "")
        
        return eventsCell
        
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.friendsListCollectionView {
            let friendsList = self.friendsListModel?[indexPath.row]
            if let nav = storyboard?.instantiateViewController(withIdentifier: "FriendsProfilePageViewController") as? FriendsProfilePageViewController {
                nav.currentFriend = currentFriend
                self.navigationController?.pushViewController(nav, animated: false)
            }
        }
    }
	
}
