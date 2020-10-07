//
//  EventSummaryViewController.swift
//  Actio
//
//  Created by senthil on 07/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventSummaryViewController: UIViewController {

	private let service = DependencyProvider.shared.networkService
	var eventDetails: EventDetail?
	var eventSummary: EventRegistrationStatus?
	
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        fetchRegistrationStatus()
    }
    

	private func fetchRegistrationStatus() {
		service.post(eventRegistrationStatusUrl, parameters: ["eventID": String(eventDetails?.id ?? 0)], onView: view) { (response: EventRegistrationStatus) in
			self.eventSummary = response
			
			self.tableView.reloadData()
		}
	}
}

// MARK: Tableview Datasource
extension EventSummaryViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		var sectionCount = 0
		
		if eventSummary?.view?.eventID != nil {
			sectionCount += 1
		}
		if let allPlayers = eventSummary?.view?.players, !allPlayers.isEmpty {
			sectionCount += 1
		}
		
		return sectionCount
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			// 1 - Event Details
			// 2 - Registration Details
			return (eventSummary?.view?.eventID != nil) ? 2 : 0
			
		case 1:
			guard let allPlayers = eventSummary?.view?.players, !allPlayers.isEmpty else {
				break
			}
			
			// 1 - All Players Header
			// 2 - Add new player cell
			return allPlayers.count + 2
			
		default:
			break
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			return getStaticCells(indexPath)
			
		case 1:
			return getPlayerCells(indexPath)
			
		default:
			break
		}
		
		return UITableViewCell()
	}
	
	func getStaticCells(_ indexPath: IndexPath) -> UITableViewCell {
		guard let cellData = eventSummary?.view else { return UITableViewCell() }
		
		switch indexPath.row {
		case 0:
			if let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailSummaryCell.reuseId, for: indexPath) as? EventDetailSummaryCell {
				cell.selectionStyle = .none
				cell.configure(cellData)
				
				return cell
			}
			
		case 1:
			if let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationDetailSummaryCell.reuseId, for: indexPath) as? RegistrationDetailSummaryCell {
				cell.selectionStyle = .none
				cell.configure(cellData)
				cell.delegate = self
				
				return cell
			}
			
		default:
			break
		}
		
		return UITableViewCell()
	}
	
	func getPlayerCells(_ indexPath: IndexPath) -> UITableViewCell {
		guard let allPlayers = eventSummary?.view?.players else { return UITableViewCell() }
		
		switch indexPath.row {
		case 0:
			if let cell = tableView.dequeueReusableCell(withIdentifier: PlayerHeaderTableViewCell.reuseId, for: indexPath) as? PlayerHeaderTableViewCell {
				cell.selectionStyle = .none
				cell.delegate = self
				
				return cell
			}
		
		case allPlayers.count + 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: AddPlayerButtonViewCell.reuseId, for: indexPath)
			cell.selectionStyle = .none
			
			return cell
			
		default:
			if let cell = tableView.dequeueReusableCell(withIdentifier: PlayerSummaryTableViewCell.reuseId, for: indexPath) as? PlayerSummaryTableViewCell {
				cell.selectionStyle = .none
				cell.configure(allPlayers[indexPath.row - 1])
				
				return cell
			}
		}
		
		return UITableViewCell()
	}
}

// MARK: TableView and Cell Delegates
extension EventSummaryViewController: UITableViewDelegate, EditRegistrationDelegate, AddPlayerDelegate {
	func editRegistration() {
		
	}
	
	func addPlayer() {
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}
