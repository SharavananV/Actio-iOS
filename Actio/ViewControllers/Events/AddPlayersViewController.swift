//
//  AddPlayersViewController.swift
//  Actio
//
//  Created by senthil on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import CoreData

class AddPlayersViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	fileprivate var formData: [FormCellType]?
	private var masterData: EventMaster?
	private var currentPlayer: Player? = Player()
	private var allPlayers: [CDPlayer]? = [CDPlayer]()
	var eventDetails: EventDetail?
	var registrationId: Int?
	var updateMode: Bool = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.reuseId)
		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
        tableView.register(JustTextTableViewCell.self, forCellReuseIdentifier: JustTextTableViewCell.reuseId)
		tableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
		tableView.register(UserSelectionTableViewCell.self, forCellReuseIdentifier: UserSelectionTableViewCell.reuseId)
		tableView.register(EventAddPlayerTableViewCell.self, forCellReuseIdentifier: EventAddPlayerTableViewCell.reuseId)
		
		var frame = CGRect.zero
		frame.size.height = .leastNormalMagnitude
		tableView.tableHeaderView = UIView(frame: frame)
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.delegate = self
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Proceed", style: .done, target: self, action: #selector(self.proceedTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
		
		fetchMasterData()
		fetchPlayers()
    }
	
	@objc func proceedTapped() {
		var players = [[String: Any]]()
		
		allPlayers?.forEach({ (player) in
			players.append(player.parameters())
		})
		let parameters: [String : Any] = ["registrationID":  registrationId ?? 0,
						  "players" : players]
		service.post(addPlayersUrl, parameters: parameters, onView: view) { (response: ResponseHolder) in
			if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventSummaryViewController") as? EventSummaryViewController {
				vc.eventDetails = self.eventDetails
				self.navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	private func fetchMasterData(countryId: String? = nil, stateId: String? = nil, sportsId: String? = nil) {
		let parameters = [ "countryID": countryId ?? "", "stateID": stateId ?? "", "sportsID": sportsId ?? ""]
		
		service.post(eventMasterUrl, parameters: parameters, onView: view) { (response: EventsMasterResponse) in
			self.masterData = response.master
			
			self.prepareFormData()
		}
	}
	
	private func prepareFormData() {
		guard let eventDetails = eventDetails else { return }
		
		let allGenders = self.masterData?.gender?.map({ (gender) -> String in
			return gender.gender ?? ""
		}) ?? []
		
		let gender = self.masterData?.gender?.first(where: {
			$0.id == self.currentPlayer?.gender
		})
		
		let isdCodes = self.masterData?.country?.map({ (country) -> String in
			return country.code ?? ""
		}) ?? []
		
		let allPositions = self.masterData?.position?.map({ (position) -> String in
			return position.position ?? ""
		}) ?? []
		
		let position = self.masterData?.position?.first(where: {
			String($0.id ?? 0) == self.currentPlayer?.position
		})
		
		let startedText = NSMutableAttributedString(string:"minimum \(eventDetails.minMemberPerTeam ?? 0) player\nmaximum \(eventDetails.maxMemberPerTeam ?? 0) player", attributes: [NSAttributedString.Key.font: AppFont.PoppinsRegular(size: 12), NSAttributedString.Key.foregroundColor : UIColor.themeRed])
		startedText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 8, length: 1))
		startedText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 25, length: 1))
		
		let buttonTitle = updateMode ? "UPDATE" : "ADD"
		
		let formData: [FormCellType] = [
			.attrText(startedText, .right),
			.searchPlayer,
			.textEdit(TextEditModel(key: "playerName", textValue: currentPlayer?.name, contextText: "Player Name", placeHolder: "Player Name")),
			.textPicker(TextPickerModel(key: "gender", textValue: gender?.gender, allValues: allGenders, contextText: "Gender", placeHolder: "Select Gender")),
			.date(DatePickerModel(key: "dob", minDate: nil, maxDate: Date(), dateValue: currentPlayer?.dob?.toDate, contextText: "DOB (dd-mm-yyyy)")),
			.textPicker(TextPickerModel(key: "isdCode", textValue: currentPlayer?.isdCode, allValues: isdCodes, contextText: "Country", placeHolder: "Select Country")),
			.textEdit(TextEditModel(key: "mobileNumber", textValue: currentPlayer?.mobileNumber, contextText: "Mobile Number", placeHolder: "Mobile Number", keyboardType: .phonePad, isSecure: false)),
			.textEdit(TextEditModel(key: "emailID", textValue: currentPlayer?.email, contextText: "Email ID", placeHolder: "Email ID", keyboardType: .emailAddress, isSecure: false)),
			.textPicker(TextPickerModel(key: "gamePosition", textValue: position?.position, allValues: allPositions, contextText: "Game Position", placeHolder: "Select Game Position")),
			.button(buttonTitle)
		]
		
		self.formData = formData
		
		tableView.reloadData()
	}
}

// MARK: TableView methods
extension AddPlayersViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return formData?.count ?? 0
		} else {
			return allPlayers?.count ?? 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		
		switch indexPath.section {
		case 0:
			cell = getCell(forIndexPath: indexPath)
		case 1:
			guard let player = allPlayers?[indexPath.row], let playerCell = tableView.dequeueReusableCell(withIdentifier: EventAddPlayerTableViewCell.reuseId, for: indexPath) as? EventAddPlayerTableViewCell else {
				return UITableViewCell()
			}
			
			playerCell.configure(player)
			cell = playerCell
			
		default:
			break
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 1 && allPlayers?.isEmpty == false ? "Players" : nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? 0 : UITableView.automaticDimension
	}
	
	private func getCell(forIndexPath indexPath: IndexPath) -> UITableViewCell? {
		var cell: UITableViewCell? = nil
		
		guard let cellData = self.formData?[indexPath.row] else { return UITableViewCell() }
		
		switch cellData {
		case .date(let model):
			guard let dateCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.reuseId, for: indexPath) as? DatePickerTableViewCell else {
				return UITableViewCell()
			}
			
			dateCell.configure(model)
			dateCell.delegate = self
			cell = dateCell
			
		case .textEdit(let model):
			guard let textEditCell = tableView.dequeueReusableCell(withIdentifier: TextEditTableViewCell.reuseId, for: indexPath) as? TextEditTableViewCell else {
				return UITableViewCell()
			}
			
			textEditCell.configure(model)
			textEditCell.delegate = self
			cell = textEditCell
			
		case .textPicker(let model):
			guard let textPickerCell = tableView.dequeueReusableCell(withIdentifier: TextPickerTableViewCell.reuseId, for: indexPath) as? TextPickerTableViewCell else {
				return UITableViewCell()
			}
			
			textPickerCell.configure(model)
			textPickerCell.delegate = self
			cell = textPickerCell
			
		case .searchPlayer:
			guard let playerCell = tableView.dequeueReusableCell(withIdentifier: UserSelectionTableViewCell.reuseId, for: indexPath) as? UserSelectionTableViewCell else {
				return UITableViewCell()
			}
			
			playerCell.delegate = self
			cell = playerCell
			
		case .attrText(let text, let alignment):
			guard let textCell = tableView.dequeueReusableCell(withIdentifier: JustTextTableViewCell.reuseId, for: indexPath) as? JustTextTableViewCell else {
				return UITableViewCell()
			}
			
			textCell.configure(nil, text, alignment: alignment)
			cell = textCell
			
		case .button(let title):
			guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: FootnoteButtonTableViewCell.reuseId, for: indexPath) as? FootnoteButtonTableViewCell else {
				return UITableViewCell()
			}
			
			buttonCell.configure(title: title, delegate: self)
			cell = buttonCell
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		if indexPath.section == 0 { return nil }
		
		var configuration = UISwipeActionsConfiguration()
		
		let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
			guard let player = self.allPlayers?[indexPath.row] else { return }
			
			let alert = UIAlertController(title: nil, message: "Are you sure want to delete this player?", preferredStyle: .alert)
			
			let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
			})
			alert.addAction(cancel)
			let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
				PersistentContainer.context.delete(player)
				self.allPlayers?.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .fade)
				
				PersistentContainer.saveContext()
			})
			alert.addAction(ok)
			
			DispatchQueue.main.async(execute: {
				self.present(alert, animated: true)
			})
		}
		let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
			guard let player = self.allPlayers?[indexPath.row] else { return }
			
			self.currentPlayer = Player(player)
			self.updateMode = true
			self.prepareFormData()
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
}

// MARK: Cell Delegate
extension AddPlayersViewController: UserSelectionProtocol, CellDataFetchProtocol, TextPickerDelegate, FootnoteButtonDelegate {
	func footnoteButtonCallback(_ title: String) {
		view.endEditing(true)
		
		if updateMode {
			do {
				guard let playerId = currentPlayer?.id else { return }
				if let cdPlayer = try PersistentContainer.context.fetch(CDPlayer.fetchRequest(withID: playerId, eventId: (self.eventDetails?.id ?? 0), subscriberId: (registrationId ?? 0))).first {
					cdPlayer.eventId = Int64(eventDetails?.id ?? 0)
					cdPlayer.subscriberId = Int64(registrationId ?? 0)
					cdPlayer.dob = currentPlayer?.dob
					cdPlayer.email = currentPlayer?.email
					cdPlayer.gender = Int16(currentPlayer?.gender ?? 0)
					cdPlayer.isdCode = currentPlayer?.isdCode
					cdPlayer.mobileNumber = currentPlayer?.mobileNumber
					cdPlayer.name = currentPlayer?.name
					cdPlayer.position = currentPlayer?.position
					
					PersistentContainer.saveContext()
					fetchPlayers()
					currentPlayer = Player()
					updateMode = false
					
					prepareFormData()
				}
			} catch let error as NSError {
				print("Could not fetch. \(error), \(error.userInfo)")
			}
		} else {
			if let playerCount = allPlayers?.count, playerCount >= (eventDetails?.maxMemberPerTeam ?? 0) {
				view.makeToast("Can add minimum \(eventDetails?.minMemberPerTeam ?? 0) and maximum \(eventDetails?.maxMemberPerTeam ?? 0) players only")
			} else {
				guard let player = currentPlayer else { return }
				
				addPlayerToCoreData(player)
			}
		}
	}
	
	func valueChanged(keyValuePair: (key: String, value: String)) {
		switch keyValuePair.key {
		case "playerName":
			currentPlayer?.name = keyValuePair.value
		case "dob":
			currentPlayer?.dob = keyValuePair.value
		case "mobileNumber":
			currentPlayer?.mobileNumber = keyValuePair.value
		case "emailID":
			currentPlayer?.email = keyValuePair.value
		default:
			break
		}
	}
	
	func didPickText(_ key: String, index: Int) {
		switch key {
		case "gender":
			if let id = self.masterData?.gender?[index].id {
				currentPlayer?.gender = id
			}
			
		case "isdCode":
			if let id = self.masterData?.country?[index].code {
				currentPlayer?.isdCode = id
			}
			
		case "gamePosition":
			if let id = self.masterData?.position?[index].id {
				currentPlayer?.position = String(id)
			}
			
		default:
			break
		}
	}
	
	func selectedPlayer(_ player: SearchUserModel) {
		if player.ageAllow == "0" {
			view.makeToast("This Player is not eligible to this Event")
		}
		else {
			currentPlayer?.name = player.fullName
			currentPlayer?.dob = player.dob
			currentPlayer?.email = player.emailID
			currentPlayer?.gender = player.gender
			currentPlayer?.isdCode = player.isdCode
			currentPlayer?.mobileNumber = player.mobileNumber
			
			prepareFormData()
		}
	}
	
	func resetData() {
		currentPlayer = Player()
		
		prepareFormData()
	}
	
	func playerList(forSearchText text: String, completion: @escaping ([SearchUserModel]) -> Void) {
		service.post(searchPlayerUrl, parameters: ["search": text, "eventID": eventDetails?.id ?? 0], onView: view) { (response: SearchPlayerResponse) in
			completion(response.search ?? [])
		}
	}
	
	func reloadHeight() {
		tableView.beginUpdates()
		tableView.endUpdates()
	}
}

// MARK: CoreData
extension AddPlayersViewController {
	private func addPlayerToCoreData(_ player: Player) {
		let validationResult = validatePlayer(player)
		
		switch validationResult {
		case .valid:
			let cdPlayer = CDPlayer(context: PersistentContainer.context)
			
			cdPlayer.id = Int64(Date().uniqueId)
			cdPlayer.eventId = Int64(eventDetails?.id ?? 0)
			cdPlayer.subscriberId = Int64(registrationId ?? 0)
			cdPlayer.dob = player.dob
			cdPlayer.email = player.email
			cdPlayer.gender = Int16(player.gender ?? 0)
			cdPlayer.isdCode = player.isdCode
			cdPlayer.mobileNumber = player.mobileNumber
			cdPlayer.name = player.name
			cdPlayer.position = player.position
			
			PersistentContainer.saveContext()
			allPlayers?.append(cdPlayer)
			currentPlayer = Player()
			
			prepareFormData()
		
		case .invalid(let message):
			self.view.makeToast(message)
		}
	}
	
	private func fetchPlayers() {
		do {
			self.allPlayers = try PersistentContainer.context.fetch(CDPlayer.fetchRequest())
			
			self.tableView.reloadData()
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	private func validatePlayer(_ player: Player) -> ValidType {
		if Validator.isValidRequiredField(player.name ?? "") != .valid {
			return .invalid(message: "Enter Player Name")
		}
		if Validator.isValidRequiredField(String(player.gender ?? 0)) != .valid {
			return .invalid(message: "Select Gender")
		}
		if Validator.isValidRequiredField(player.dob ?? "") != .valid {
			return .invalid(message: "Enter Date Of Birth")
		}
		if let dob = player.dob?.toDate, let minAge = eventDetails?.minAge, let maxAge = eventDetails?.maxAge {
			let age = dob.age()
			if !(age >= minAge && age <= maxAge) {
				return .invalid(message: "This Event has a \(minAge) to \(maxAge) age limit.")
			}
		}
		if Validator.isValidRequiredField(player.isdCode ?? "") != .valid {
			return .invalid(message: "Select Country Code")
		}
		if Validator.isValidRequiredField(player.mobileNumber ?? "") != .valid {
			return .invalid(message: "Enter Mobile Number")
		}
		if Validator.isValidEmail(player.email ?? "") != .valid {
			return .invalid(message: "Enter Valid Email ID")
		}
		if Validator.isValidRequiredField(player.position ?? "") != .valid {
			return .invalid(message: "Select Game Position")
		}
		
		return .valid
	}
}

private enum FormCellType {
	case searchPlayer
	case date(DatePickerModel)
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case attrText(NSAttributedString, NSTextAlignment)
	case button(String)
}

fileprivate class Player: Codable {
	internal init() { }
	
	var name: String?
	var id, gender, eventId, subscriberId: Int?
	var dob, isdCode, mobileNumber, email: String?
	var position: String?
	
	init(_ player: CDPlayer) {
		self.id = Int(player.id)
		self.name = player.name
		self.gender = Int(player.gender)
		self.dob = player.dob
		self.isdCode = player.isdCode
		self.mobileNumber = player.mobileNumber
		self.email = player.email
		self.position = player.position
		self.eventId = Int(player.eventId)
		self.subscriberId = Int(player.subscriberId)
	}
}
