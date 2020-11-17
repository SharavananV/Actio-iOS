//
//  ChatHistoryViewController.swift
//  Actio
//
//  Created by senthil on 14/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ChatHistoryViewController: UIViewController {

	private let service = DependencyProvider.shared.networkService
	private var allConversations: [Conversation]?
	
	@IBOutlet var tableView: UITableView!
	
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action:
									#selector(ChatHistoryViewController.handleRefresh(_:)),
								 for: .valueChanged)
		refreshControl.tintColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
		
		return refreshControl
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Messages"
		self.tableView.addSubview(self.refreshControl)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		service.post(allConversationUrl, parameters: nil, onView: view, shouldDismissOnError: true) { (response: ConversationResponse) in
			self.allConversations = response.conversation
			
			self.tableView.reloadData()
		}
	}
	
	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
		service.post(allConversationUrl, parameters: nil, onView: view) { (response: ConversationResponse) in
			self.allConversations = response.conversation
			
			self.tableView.reloadData()
			refreshControl.endRefreshing()
		}
	}
}

// MARK: Tableview methods
extension ChatHistoryViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allConversations?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let data = allConversations?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.reuseId, for: indexPath) as? ConversationTableViewCell {
			cell.configure(data)
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let data = allConversations?[indexPath.row], let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
			vc.conversation = data
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}
