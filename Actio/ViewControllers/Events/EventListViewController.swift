//
//  EventListViewController.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {

	private var eventList: [EventCategory]?
	
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        mockData()
    }
    
	private func mockData() {
		let response = """
{
    "status": "200",
    "eventCategory": [
        {
            "sports_id": 3,
            "sports_name": "Badminton",
            "events": [
                {
                    "event_id": 165,
                    "event_name": "England",
                    "event_category": " Mens Doubles ",
                    "event_type": "Team",
                    "event_address": "Coimbatore Golf Club, Coimbatore",
                    "event_start_date": "TUE AUG 18 2020",
                    "event_end_date": "WED AUG 19 2020",
                    "event_logo": "images/event/158587.jpeg",
                    "is_registration_open": 2
                },
                {
                    "event_id": 189,
                    "event_name": "RNS",
                    "event_category": " Mens Doubles ",
                    "event_type": "Team",
                    "event_address": "Coimbatore Golf Club, Coimbatore",
                    "event_start_date": "SAT JUN 20 2020",
                    "event_end_date": "SUN OCT 25 2020",
                    "event_logo": "images/event/613417.jpeg",
                    "is_registration_open": 2
                }
            ]
        },
        {
            "sports_id": 4,
            "sports_name": "Cricket",
            "events": [
                {
                    "event_id": 156,
                    "event_name": "Sri Lanka Plan For Lankan Premier League In 2020",
                    "event_category": " Men's Cricket ",
                    "event_type": "Team",
                    "event_address": "Coimbatore Golf Club, Coimbatore",
                    "event_start_date": "FRI JUL 24 2020",
                    "event_end_date": "THU AUG 06 2020",
                    "event_logo": "images/event/196860.jpeg",
                    "is_registration_open": 2
                }
            ]
        }
    ]
}
"""
		guard let data = response.data(using: String.Encoding.utf8) else { return }
		
		do {
			let eventResponse = try JSONDecoder().decode(EventCategoryResponse.self, from: data)
			eventList = eventResponse.eventCategory
			
			tableView.reloadData()
		} catch {
			print("Error Decoding")
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
}
