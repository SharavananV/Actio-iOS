//
//  ProfilePageViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class ProfilePageViewController: UIViewController {

    @IBOutlet var profileEmailLabel: UILabel!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet weak var friendsListCollectionView: UICollectionView!
    private let service = DependencyProvider.shared.networkService
    var userDetails: User?
    var friendsListModel : [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listFriends()

		profileEmailLabel.text = userDetails?.emailID
		profileNameLabel.text = userDetails?.fullName
		if let url = URL(string: userDetails?.profileImage ?? "") {
			profileImageView.load(url: url)
		}
        friendsListCollectionView.delegate = self
        friendsListCollectionView.dataSource = self
        myProfile()
    }
    
    func myProfile() {
        service.post(myProfileUrl, parameters: nil, onView: view) { (response: FindFriendResponse) in
            self.userDetails = response.profile
            self.profileEmailLabel.text = self.userDetails?.emailID
            self.profileNameLabel.text = self.userDetails?.fullName

        }
    }
   
     func listFriends() {
        service.post(friendListUrl, parameters: ["friendID": 3413], onView: view) { (response: FindFriendResponse) in
            self.friendsListModel = response.list
            self.friendsListCollectionView.reloadData()
        }
    }
    
	@IBAction func chatAction(_ sender: Any) {
		
	}
}
extension ProfilePageViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendsListModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FriendsListCollectionViewCell", for: indexPath) as? FriendsListCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let friendsList = self.friendsListModel?[indexPath.row] else {
            return UICollectionViewCell()
        }
        if let profileImage = friendsList.profileImage,let imagePath = URL(string:  baseUrl + profileImage) {
            cell.friendsProfileImageView.load(url: imagePath)
        }
        cell.friendsProfileImageView.layer.cornerRadius = cell.friendsProfileImageView.frame.height/2
        cell.friendsProfileImageView.clipsToBounds = true
        cell.friendsNameLabel.text = friendsList.fullName
        return cell
    }
}
