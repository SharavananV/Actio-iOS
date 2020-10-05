//
//  AddPlayersViewController.swift
//  Actio
//
//  Created by senthil on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AddPlayersViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	let service = DependencyProvider.shared.networkService
	fileprivate var formData: [FormCellType]?
	private var masterData: EventMaster?
	private var currentPlayer: Player? = Player()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.reuseId)
		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
        tableView.register(JustTextTableViewCell.self, forCellReuseIdentifier: JustTextTableViewCell.reuseId)
		tableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
		tableView.register(UserSelectionTableViewCell.self, forCellReuseIdentifier: UserSelectionTableViewCell.reuseId)
		
		var frame = CGRect.zero
		frame.size.height = .leastNormalMagnitude
		tableView.tableHeaderView = UIView(frame: frame)
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.delegate = self
		
		fetchMasterData()
    }
	
	private func fetchMasterData(countryId: String? = nil, stateId: String? = nil, sportsId: String? = nil) {
		let parameters = [ "countryID": countryId ?? "", "stateID": stateId ?? "", "sportsID": sportsId ?? ""]
		
		service.post(eventMasterUrl, parameters: parameters, onView: view) { (response: EventsMasterResponse) in
			self.masterData = response.master
			
			self.prepareFormData()
		}
	}
	
	private func prepareFormData() {
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
		
		let startedText = NSMutableAttributedString(string:"minimum 2 player\nmaximum 4 player", attributes: [NSAttributedString.Key.font: AppFont.PoppinsRegular(size: 12), NSAttributedString.Key.foregroundColor : UIColor.themeRed])
		startedText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 8, length: 1))
		startedText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 25, length: 1))
		
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
			.button("Add")
		]
		
		self.formData = formData
		
		tableView.reloadData()
	}
}

extension AddPlayersViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return formData?.count ?? 0
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 1 ? "Players" : nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? 0 : UITableView.automaticDimension
	}
}

extension AddPlayersViewController: UserSelectionProtocol, CellDataFetchProtocol, TextPickerDelegate, FootnoteButtonDelegate {
	func footnoteButtonCallback(_ title: String) {
		// TODO: Validate max and min players
		
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
		service.post(searchPlayerUrl, parameters: ["search": text, "eventID": 209], onView: view) { (response: SearchPlayerResponse) in
			completion(response.search ?? [])
		}
	}
	
	func reloadHeight() {
		tableView.beginUpdates()
		tableView.endUpdates()
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
	var id, name: String?
	var gender: Int?
	var dob, isdCode, mobileNumber, email: String?
	var position: String?
}
