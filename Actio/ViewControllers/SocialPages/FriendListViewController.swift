//
//  FriendListViewController.swift
//  Actio
//
//  Created by senthil on 09/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var allUsers: [Friend]?
	
	private func listFriends(_ searchText: String) {
		service.post(listFriendsUrl, parameters: ["search": searchText.lowercased()], onView: view) { (response: FindFriendResponse) in
			if let allUsers = response.find {
				self.allUsers = allUsers
			}
			
			self.tableView.reloadData()
		}
	}
}

extension FriendListViewController: UISearchBarDelegate {
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		if let searchText = searchBar.text, !searchText.isEmpty {
			listFriends(searchText)
		} else {
			resetData()
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		
		if let searchText = searchBar.text, !searchText.isEmpty {
			listFriends(searchText)
		} else {
			resetData()
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		resetData()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText == "" {
			resetData()
		}
	}
	
	private func resetData() {
		searchBar.text = nil
		allUsers = nil
		
		tableView.reloadData()
	}
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate, FriendListDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allUsers?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendListTableViewCell.reuseId, for: indexPath) as? FriendListTableViewCell else {
			return UITableViewCell()
		}
		
		cell.configure(allUsers?[indexPath.row])
		cell.selectionStyle = .none
		cell.delegate = self
		
		return cell
	}
	
	func addFriendTapped(_ subscriberId: Int?, friendStatus: Int?) {
		switch friendStatus {
		case 0:
			sendAddFriendCall(subscriberId)
		case 1:
			view.makeToast("You already requested")
		case 2:
			view.makeToast("You are friends already")
		default:
			view.makeToast("You have received request already")
		}
	}
	
	func sendAddFriendCall(_ subscriberId: Int?) {
		guard let subscriberId = subscriberId else { return }
		
		service.post(friendActionUrl, parameters: ["friendID": subscriberId, "actionID": "1"], onView: view) { [weak self] (response) in
			if response["status"] as? String == "200" {
				let addedFriend = self?.allUsers?.first(where: { $0.subscriberID == subscriberId })
				addedFriend?.friendsStatus = 1
				self?.view.makeToast("Request sent successfully")
				
				self?.tableView.reloadData()
			}
		}
	}
}
