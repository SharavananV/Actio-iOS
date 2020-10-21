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
	
    private var friendsEventsAssociated : [EventAssociated]?

	@IBOutlet var chatButton: UIButton!
	@IBOutlet var acceptButton: ActioGradientButton!
	@IBOutlet var rejectButton: ActioGradientButton!
	@IBOutlet var shareButton: UIButton!
	@IBOutlet var friendsButtonStackView: UIStackView!
	
	private let service = DependencyProvider.shared.networkService
	private var friendsListModel : [Friend]?
	private var currentFriend: Profile?
	var friendId: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		friendsPageBackgroundView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
		self.friendsProfileImageView.layer.cornerRadius = self.friendsProfileImageView.frame.height/2
		self.friendsProfileImageView.clipsToBounds = true

        friendsListCollectionView.delegate = self
        friendsListCollectionView.dataSource = self
        eventsAssociatedCollectionView.dataSource = self
        eventsAssociatedCollectionView.delegate = self
		friendsListCall()
	}
	
	func friendsListCall() {
		let parameters = ["friendID": friendId ?? 0]
		
		service.post(friendListUrl, parameters: parameters , onView: view) { [weak self] (response: FriendsListResponse) in
			self?.currentFriend = response.profile
			self?.friendsListModel = response.list
			self?.friendsEmailLabel.text = self?.currentFriend?.emailID
			self?.friendsProfileNameLabel.text = self?.currentFriend?.fullName
			self?.setButtonTexts(self?.currentFriend?.friendsStatus)
			self?.friendsEventsAssociated = response.eventAssociated
			
			if let image = self?.currentFriend?.profileImage, let url = URL(string: baseImageUrl + image) {
				self?.friendsProfileImageView.load(url: url)
			}
			
			self?.friendsListCollectionView.reloadData()
			self?.eventsAssociatedCollectionView.reloadData()
		}
	}
	
	@IBAction func chatAction(_ sender: Any) {
		if let vc = UIStoryboard(name: "Social", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
			vc.conversation = Conversation(subscriberID: self.currentFriend?.subscriberID, subscriberDisplayID: self.currentFriend?.subscriberDisplayID, fullName: self.currentFriend?.fullName, username: self.currentFriend?.username, emailID: self.currentFriend?.emailID, profileImage: self.currentFriend?.profileImage, chatID: nil, message: nil, unseen: nil)
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	@IBAction func firstFriendButtonAction(_ sender: UIButton) {
		if sender.title(for: .normal) == "Send Friend Request" {
			friendActionAPI("1")
		} else if sender.title(for: .normal) == "Accept" {
			friendActionAPI("2")
		}
	}
	
	@IBAction func secondFriendButtonAction(_ sender: UIButton) {
		var actionString = ""
		if sender.title(for: .normal) == "UnFriend" {
			actionString = "5"
		} else if sender.title(for: .normal) == "Reject" {
			actionString = "4"
		} else {
			return
		}
		
		let alert = UIAlertController(title: nil, message: "Are you sure want to \(sender.title(for: .normal)?.lowercased() ?? "do this")?", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
			self?.friendActionAPI(actionString)
		}
		alert.addAction(okAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	private func friendActionAPI(_ action: String) {
		service.post(friendActionUrl, parameters: ["friendID": friendId ?? 0, "actionID": action], onView: view) { [weak self] (response) in
			if response["status"] as? String == "200" {
				self?.setButtonTexts(Int(action))
			}
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
				nav.friendId = friendsList?.subscriberID
				self.navigationController?.pushViewController(nav, animated: false)
			}
		}
	}
}

// MARK: Helpers
extension FriendsProfilePageViewController {
	private func setButtonTexts(_ friendStatus: Int?, isPrevious: Bool = false) {
		switch (friendStatus, isPrevious) {
		case (0, false), (4, _), (5, _):
			self.acceptButton.setTitle("Send Friend Request", for: .normal)
			self.rejectButton.removeFromSuperview()
			self.friendsButtonStackView.removeArrangedSubview(self.rejectButton)
			
		case (1, _):
			self.acceptButton.setTitle("Friend Request Sent", for: .normal)
			self.rejectButton.removeFromSuperview()
			self.friendsButtonStackView.removeArrangedSubview(self.rejectButton)
			
		case (2, _):
			self.acceptButton.setTitle("Friends", for: .normal)
			self.rejectButton.setTitle("UnFriend", for: .normal)
			
		case (3, false):
			self.acceptButton.setTitle("Accept", for: .normal)
			self.rejectButton.setTitle("Reject", for: .normal)
			
		default:
			break
		}
	}
}
