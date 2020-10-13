//
//  FriendsProfilePageViewController.swift
//  Actio
//
//  Created by apple on 13/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class FriendsProfilePageViewController: UIViewController {

    @IBOutlet weak var friendsProfileImageView: UIImageView!
    @IBOutlet weak var friendsEmailLabel: UILabel!
    @IBOutlet weak var friendsProfileNameLabel: UILabel!
    @IBOutlet weak var friendsListCollectionView: UICollectionView!
    private let service = DependencyProvider.shared.networkService
    var friendsListModel : [List]?
    var friendID: Int?
    var friendsEmail: String?
    var friendsName: String?
    var friendsProfileImage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendsProfileImageView.layer.cornerRadius = self.friendsProfileImageView.frame.height/2
        self.friendsProfileImageView.clipsToBounds = true
        self.friendsEmailLabel.text = friendsEmail
        self.friendsProfileNameLabel.text = friendsName
        if let image = friendsProfileImage, let url = URL(string: baseImageUrl + image) {
            friendsProfileImageView.load(url: url)
        }
        friendsListCall()
        friendsListCollectionView.delegate = self
        friendsListCollectionView.dataSource = self
    }
    
    func friendsListCall() {
        let parameters:[String:Any] = ["friendID": friendID ?? 0]
           service.post(friendListUrl, parameters: parameters , onView: view) { (response: FindFriendResponse) in
           self.friendsListModel = response.list
           self.friendsListCollectionView.reloadData()
       }
   }
}
extension FriendsProfilePageViewController : UICollectionViewDelegate,UICollectionViewDataSource {
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
            nav.friendID = friendsList?.subscriberID
            nav.friendsEmail = friendsList?.emailID
            nav.friendsName = friendsList?.fullName
            nav.friendsProfileImage = friendsList?.profileImage
            self.navigationController?.pushViewController(nav, animated: false)
        }
    }
    
}
