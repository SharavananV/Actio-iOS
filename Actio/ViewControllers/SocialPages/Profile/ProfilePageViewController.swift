//
//  ProfilePageViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet var profileEmailLabel: UILabel!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet weak var profileFriendsListCollectionView: UICollectionView!
    private let service = DependencyProvider.shared.networkService
    var friendsListModel : [Friend]?
	var userDetails: Friend?
    var userName: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        profileBackgroundView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        myProfileCall()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.profileImageView.clipsToBounds = true
        profileFriendsListCollectionView.delegate = self
        profileFriendsListCollectionView.dataSource = self
    }
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        if let nav = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            nav.userDetails = self.userDetails
            self.navigationController?.pushViewController(nav, animated: false)
        }
    }
    
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        if let nav = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
            nav.userName = self.userName
            self.navigationController?.pushViewController(nav, animated: false)
        }
    }
    func myProfileCall() {
        service.post(myProfileUrl, parameters: nil, onView: view) { (response: MyProfileResponse) in
            self.userDetails = response.profile?.profile
            self.profileEmailLabel.text = self.userDetails?.emailID
            self.profileNameLabel.text = self.userDetails?.fullName
            if let url = URL(string: self.userDetails?.profileImage ?? "") {
                self.profileImageView.load(url: url)
            }
            self.userName = self.userDetails?.username
            self.friendsListModel = response.profile?.list
            self.profileFriendsListCollectionView.reloadData()
        }
    }
}
extension ProfilePageViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendsListModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let friendsList = self.friendsListModel?[indexPath.row]
		if let nav = storyboard?.instantiateViewController(withIdentifier: "FriendsProfilePageViewController") as? FriendsProfilePageViewController {
			nav.friendId = friendsList?.subscriberID
			self.navigationController?.pushViewController(nav, animated: false)
		}
	}
}