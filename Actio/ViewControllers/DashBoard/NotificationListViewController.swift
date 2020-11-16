//
//  NotificationListViewController.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class NotificationListViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var notificationList: [NotificationModel]?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        fetchNotifications()
		
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissNavigation))
		self.navigationItem.rightBarButtonItem  = cancelButton
		
		self.tableView.tableFooterView = UIView()
		
		self.title = "Notifications"
    }
	
	@objc func dismissNavigation() {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	private func fetchNotifications() {
		service.post(notificationListUrl, parameters: nil, onView: self.view) { [weak self] (response: NotificationResponse) in
			self?.notificationList = response.notification			
			self?.tableView.reloadData()
		}
	}
}

extension NotificationListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notificationList?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationListTableViewCell.reuseId, for: indexPath) as? NotificationListTableViewCell, let data = notificationList?[indexPath.row] else {
			return UITableViewCell()
		}
		
		cell.configure(data)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let notification = notificationList?[indexPath.row] {
			if notification.seenStatus != 1 {
				self.updateSeenStatus(notification, indexPath: indexPath)
			}
			
			redirectToController(notification)
		}
	}
	
	private func updateSeenStatus(_ notification: NotificationModel, indexPath: IndexPath) {
		service.post(notificationSeenUpdateUrl, parameters: ["notifyID": notification.notificationID ?? 0], onView: self.view) { [weak self] (response: UpdateSeenResponse) in
			if let cell = self?.tableView.cellForRow(at: indexPath) {
				cell.contentView.backgroundColor = .white
			}
		}
	}
	
	private func redirectToController(_ notification: NotificationModel) {
		switch notification.message?.type {
		case "friend_request", "accept_request":
			if let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsProfilePageViewController") as? FriendsProfilePageViewController {
				nav.friendId = notification.fromID
				self.navigationController?.pushViewController(nav, animated: false)
			}
			
		case "parent_submit":
			if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AcceptRejectRequestViewController") as? AcceptRejectRequestViewController {
				vc.childID = String(notification.fromID ?? 0)
				vc.modalPresentationStyle = .fullScreen
				self.present(vc, animated: false, completion: nil)
			}
			
		case "coach_validate":
			if let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "PerformanceReviewListViewController") as? PerformanceReviewListViewController {
				vc.shouldSelectByDefault = true
				self.navigationController?.pushViewController(vc, animated: true)
			}
			
		case "parent_reject", "parent_approve":
			break
			
		default:
			break
		}
	}
}
