//
//  ContactsListViewController.swift
//  Actio
//
//  Created by senthil on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ContactsListViewController: UIViewController {

	private let service = DependencyProvider.shared.networkService
	private var friendsList: [Friend]?
	private let socketManager = SocketIOManager()
	private var loggedInUser: LoginModelResponse?
	
	var referenceId: String?
	var shareType: String?
	var message: String?
	
	@IBOutlet var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView()
		
		fetchContactsList()
				
		self.loggedInUser = UDHelper.getData(for: .loggedInUser)
		self.title = "Share"
		
		socketManager.establishConnection()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send_chat"), style: .plain, target: self, action: #selector(self.sendTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		socketManager.establishConnection()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		socketManager.closeConnection()
	}

	private func fetchContactsList() {
		service.post(contactsListUrl, parameters: nil, onView: view, shouldDismissOnError: true) { [weak self] (response: ChatListResponse) in
			self?.friendsList = response.friends
			
			self?.tableView.reloadData()
		}
	}
	
	@IBAction func selectAllTapped(_ sender: UISwitch) {
		friendsList?.forEach({
			$0.isSelected = sender.isOn
		})
		
		tableView.reloadData()
	}
	
	@objc func sendTapped() {
		let allToIds: [[String: String]]? = friendsList?.compactMap({ (friend) -> [String: String]? in
			if friend.isSelected, let toId = friend.subscriberID {
				return ["id": String(toId)]
			} else {
				return nil
			}
		})
		
		if let fromId = loggedInUser?.subscriberSeqID, let allToIds = allToIds, !allToIds.isEmpty {
			
			socketManager.shareTextMessage(
				fromId: String(fromId),
				toIds: allToIds,
				message: message ?? "",
				refId: referenceId ?? "",
				type: shareType ?? ""
			)
			
			view.makeToast("Shared successfully") { [weak self] _ in
				self?.navigationController?.popViewController(animated: true)
			}
		} else {
			view.makeToast("Select atleast one contact")
		}
	}
}

extension ContactsListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.friendsList?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactListShareCell.reuseId, for: indexPath) as? ContactListShareCell else {
			return UITableViewCell()
		}
		
		cell.configure(friendsList?[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		friendsList?[indexPath.row].isSelected = !(friendsList?[indexPath.row].isSelected ?? false)
		tableView.reloadData()
	}
}
