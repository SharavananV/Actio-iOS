//
//  EventListViewController.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {

	var tournamentId: Int?
	private var eventList: [EventCategory]?
	private let service = DependencyProvider.shared.networkService
	
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        fetchEvents()
    }
	
	private func fetchEvents() {
		service.post(eventListUrl,
					 parameters: ["tournamentID": self.tournamentId ?? 0, "search": ""],
					 onView: self.view) { (response: EventCategoryResponse) in
			self.eventList = response.eventCategory
			
			if self.eventList == nil || self.eventList?.isEmpty == true {
				self.tableView.setEmptyView(nil, "NoEvent")
			} else {
				self.tableView.backgroundView = nil
			}
			
			self.tableView.reloadData()
		}
	}
}

extension EventListViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return eventList?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return eventList?[section].events.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let eventDetail = eventList?[indexPath.section].events[indexPath.row],
			let eventCell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.reuseId, for: indexPath) as? EventListTableViewCell {
			eventCell.selectionStyle = .none
			eventCell.configure(eventDetail)
			
			return eventCell
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let headerView = tableView.dequeueReusableCell(withIdentifier: EventListHeaderCell.reuseId) as? EventListHeaderCell {
			headerView.configure(eventList?[section].sportsName)
			
			return headerView
		}
		
		return nil
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let eventDetail = eventList?[indexPath.section].events[indexPath.row],
			let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
			vc.eventId = eventDetail.eventID
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}
