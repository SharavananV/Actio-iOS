//
//  EventSummaryViewController.swift
//  Actio
//
//  Created by senthil on 07/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import CoreData

class EventSummaryViewController: UIViewController {

	private let service = DependencyProvider.shared.networkService
	var eventDetails: EventDetail?
	var eventSummary: EventRegistrationStatus?
	
	@IBOutlet var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Summary"
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(self.proceedTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
		
		self.navigationItem.hidesBackButton = true
		let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back(sender:)))
		self.navigationItem.leftBarButtonItem?.tintColor = .white
		self.navigationItem.leftBarButtonItem = newBackButton
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		fetchRegistrationStatus()
	}
	
	@objc func back(sender: UIBarButtonItem) {
		if let eventDetailsPage = self.navigationController?.viewControllers.first(where: { (controller) -> Bool in
			return controller is EventDetailViewController
		}) {
			self.navigationController?.popToViewController(eventDetailsPage, animated: true)
		}
	}
    
	@objc func proceedTapped() {
		service.post(submitRegistrationUrl, parameters: ["registrationID": String(eventSummary?.view?.registrationID ?? 0)], onView: view, handleError: false) { (response: [String: Any]) in
			
			if response["status"] as? String == "422", let errors = response["errors"] as? [[String: Any]], let message = errors.first?["msg"] as? String {
				self.view.makeToast(message)
				
				return
			} else if let msg = response["msg"] as? String {
				self.view.makeToast(msg)
			}
			
			if let eventDetailsPage = self.navigationController?.viewControllers.first(where: { (controller) -> Bool in
				return controller is EventDetailViewController
			}) {
				self.clearCoreData()
				self.navigationController?.popToViewController(eventDetailsPage, animated: true)
			}
		}
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
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard let players = eventSummary?.view?.players, indexPath.section == 1 && indexPath.row != 0 && indexPath.row != (players.count + 1) else { return nil }
		
		var configuration = UISwipeActionsConfiguration()
		
		let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
			let alert = UIAlertController(title: nil, message: "Are you sure want to delete this player?", preferredStyle: .alert)
			
			let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
			})
			alert.addAction(cancel)
			let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
				if let player = self.eventSummary?.view?.players?[indexPath.row - 1] {
					self.deletePlayer(player) { (success) in
						if success {
							self.fetchRegistrationStatus()
						}
					}
				}
			})
			alert.addAction(ok)
			
			DispatchQueue.main.async(execute: {
				self.present(alert, animated: true)
			})
		}
		let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
			if let player = self.eventSummary?.view?.players?[indexPath.row - 1] {
				self.openAddPlayersPage(player)
			}
		}
		
		editAction.backgroundColor = .white
		deleteAction.backgroundColor = .white
		
		UIImageView.appearance(
			whenContainedInInstancesOf: [UITableView.self])
			.tintColor = AppColor.OrangeColor()
		
		deleteAction.image = UIImage(named: "Icon material-delete")
		editAction.image = UIImage(named: "Icon awesome-edit")
		
		configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
		configuration.performsFirstActionWithFullSwipe = true
		
		return configuration
	}
	
	private func deletePlayer(_ player: PlayerSummary, completion: @escaping (Bool)->Void) {
		service.post(editDeletePlayerUrl, parameters: ["registrationID": String(eventSummary?.view?.registrationID ?? 0), "playerID": player.playerID ?? 0, "isRemove": true], onView: view) { (response: [String: Any]) in
			
			if let msg = response["msg"] as? String {
				self.view.makeToast(msg)
			}
			
			completion(true)
		}
	}
}

// MARK: TableView and Cell Delegates
extension EventSummaryViewController: UITableViewDelegate, EditRegistrationDelegate, AddPlayerDelegate {
	func editRegistration() {
		if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventRegistrationViewController") as? EventRegistrationViewController {
			vc.eventDetails = self.eventDetails
			vc.registrationId = self.eventSummary?.view?.registrationID
			vc.fromController = .summary
			
			let addEventModel = EventDetailsRegisterModel(self.eventSummary?.view)
			vc.addEventModel = addEventModel
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	func addPlayer() {
		openAddPlayersPage()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (tableView.cellForRow(at: indexPath) as? AddPlayerButtonViewCell) != nil {
			openAddPlayersPage()
		}
	}
	
	private func openAddPlayersPage(_ player: PlayerSummary? = nil) {
		if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPlayersViewController") as? AddPlayersViewController {
			vc.eventDetails = self.eventDetails
			vc.registrationId = eventSummary?.view?.registrationID ?? 0
			vc.summaryPlayers = eventSummary?.view?.players
			vc.fromController = player == nil ? .summaryAdd : .summaryUpdate
			vc.updatingPlayer = player
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	func clearCoreData() {
		let fetchRequest = CDPlayer.fetchRequest(eventId: (eventDetails?.id ?? 0))
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		deleteRequest.resultType = .resultTypeObjectIDs
		
		do {
			let context = PersistentContainer.context
			let result = try context.execute(
				deleteRequest
			)
			
			guard
				let deleteResult = result as? NSBatchDeleteResult,
				let ids = deleteResult.result as? [NSManagedObjectID]
			else { return }
			
			let changes = [NSDeletedObjectsKey: ids]
			NSManagedObjectContext.mergeChanges(
				fromRemoteContextSave: changes,
				into: [context]
			)
		} catch {
			print(error as Any)
		}
	}
}
