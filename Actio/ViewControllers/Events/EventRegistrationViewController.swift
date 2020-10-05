//
//  EventRegistrationViewController.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import IQKeyboardManager

class EventRegistrationViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	let service = DependencyProvider.shared.networkService
	var masterData: EventMaster?
	fileprivate var formData: [FormCellType]?
	let addEventModel = EventDetailsRegisterModel()
	var eventDetails: EventDetail?
	
	var countryName, stateName: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
		tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
		tableView.separatorStyle = .none
		
		self.title = "Event Registration"
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Proceed", style: .done, target: self, action: #selector(self.proceedTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
		
		IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
		addEventModel.eventID = String(eventDetails?.id ?? 0)
		
        fetchMasterData()
    }
	
	deinit {
		IQKeyboardManager.shared().previousNextDisplayMode = .alwaysShow
	}
	
	@objc func proceedTapped() {
		service.post(eventRegistrationPart1Url, parameters: addEventModel.parameters(), onView: view) { (response: EventRegistrationResponse) in
			if let errors = response.errors {
				self.view.makeToast(errors.first?.msg)
			}
			else if let msg = response.msg {
				self.view.makeToast(msg)
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
		guard let eventDetails = self.eventDetails else { return }
		
		let registerBy = self.masterData?.registerBy?.map({
			$0.registerBy ?? ""
		}) ?? []
		
		let registerByValue = self.masterData?.registerBy?.first(where: {
			String($0.id ?? 0) == self.addEventModel.registerBy
			})?.registerBy
		
		let filteredAgeGroups = self.masterData?.ageGroup?.filter({ (ageGroup) -> Bool in
			guard let ageGroupId = ageGroup.id, let minAgeGroupID = eventDetails.minAgeGroupID, let maxAgeGroupID = eventDetails.maxAgeGroupID else { return false }
			
			return ageGroupId >= minAgeGroupID && ageGroupId <= maxAgeGroupID
		})
		
		let ageGroups = filteredAgeGroups?.map({ (group) -> String in
			return group.groupName ?? ""
		}) ?? []
		
		let selectedAgeGroup = filteredAgeGroups?.first(where: {
			String($0.id ?? 0) == self.addEventModel.ageGroup
		})
		
		let countries = self.masterData?.country?.map({ (country) -> String in
			return country.country ?? ""
		}) ?? []
		
		let states = self.masterData?.state?.map({ (state) -> String in
			return state.state ?? ""
		}) ?? []
		
		let cities = self.masterData?.city?.map({ (city) -> String in
			return city.city ?? ""
		}) ?? []
		
		let selectedCity = self.masterData?.city?.first(where: {
			String($0.id ?? 0) == self.addEventModel.cityID
		})
		
		let isCoachString = NSAttributedString(string: "Do you want to include Coach Information", attributes: [.font : AppFont.PoppinsSemiBold(size: 14)])
		
		var formData: [FormCellType] = [
			.textPicker(TextPickerModel(key: "registerBy", textValue: registerByValue, allValues: registerBy, contextText: "Registration By", placeHolder: "Select Register By")),
			.textEdit(TextEditModel(key: "registerAs", textValue: eventDetails.type, contextText: "Register As", enabled: false)),
			.textEdit(TextEditModel(key: "playerType", textValue: eventDetails.playerType, contextText: "Player Type", enabled: false)),
			.textPicker(TextPickerModel(key: "ageGroup", textValue: selectedAgeGroup?.groupName, allValues: ageGroups, contextText: "Age Group", placeHolder: "Select Age Group")),
			.textEdit(TextEditModel(key: "teamName", textValue: addEventModel.teamName, contextText: "Team Name", placeHolder: "Team name allows a-z,0-9,_,.")),
			.toggle(ToggleViewModel(key: "isCoach", contextText: isCoachString, defaultValue: (addEventModel.isCoach == true))),
			.textPicker(TextPickerModel(key: "country", textValue: countryName, allValues: countries, contextText: "Country", placeHolder: "Select Country")),
			.textPicker(TextPickerModel(key: "state", textValue: stateName, allValues: states, contextText: "State", placeHolder: "Select State")),
			.textPicker(TextPickerModel(key: "cityID", textValue: selectedCity?.city, allValues: cities, contextText: "City", placeHolder: "Select City"))
		]
		
		if addEventModel.isCoach == true {
			let allZipCodes = self.masterData?.country?.map({ (country) -> String in
				return country.code ?? ""
			}) ?? []
			
			let coachData: [FormCellType] = [
				.textEdit(TextEditModel(key: "coachName", textValue: addEventModel.coachName, contextText: "Coach Name", placeHolder: "Coach Name")),
				.textPicker(TextPickerModel(key: "coachIsd", textValue: addEventModel.coachIsd, allValues: allZipCodes, contextText: "Country Code")),
				.textEdit(TextEditModel(key: "coachMobile", textValue: addEventModel.coachMobile, contextText: "Coach Mobile Number", placeHolder: "Coach Mobile Number", keyboardType: .phonePad, isSecure: false)),
				.textEdit(TextEditModel(key: "coachEmail", textValue: addEventModel.coachEmail, contextText: "Coach Email ID", placeHolder: "Coach Email ID", keyboardType: .emailAddress, isSecure: false))
			]
			
			formData.insert(contentsOf: coachData, at: 6)
		}
		
		self.formData = formData
		
		UIView.setAnimationsEnabled(false)
		self.tableView.beginUpdates()
		self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
		self.tableView.endUpdates()
	}
}

extension EventRegistrationViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.formData?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		guard let cellData = self.formData?[indexPath.row] else { return UITableViewCell() }
		
		switch cellData {
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
			
		case .button(let title):
			guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: FootnoteButtonTableViewCell.reuseId, for: indexPath) as? FootnoteButtonTableViewCell else {
				return UITableViewCell()
			}
			
			buttonCell.configure(title: title, delegate: self)
			cell = buttonCell
		
		case .toggle(let model):
			guard let toggleCell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseId, for: indexPath) as? SwitchTableViewCell else {
				return UITableViewCell()
			}
			
			toggleCell.configure(model, delegate: self)
			cell = toggleCell
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
}

// MARK: Cell Delegates
extension EventRegistrationViewController: CellDataFetchProtocol, TextPickerDelegate, FootnoteButtonDelegate, SwitchCellDelegate {
	func valueChanged(keyValuePair: (key: String, value: String)) {
		guard let codingKey = EventDetailsRegisterModel.CodingKeys(rawValue: keyValuePair.key) else { return }
		
		switch codingKey {
		case .teamName:
			self.addEventModel.teamName = keyValuePair.value
		case .coachName:
			self.addEventModel.coachName = keyValuePair.value
		case .coachMobile:
			self.addEventModel.coachMobile = keyValuePair.value
		case .coachEmail:
			self.addEventModel.coachEmail = keyValuePair.value
		default:
			break;
		}
		
		prepareFormData()
	}
	
	func didPickText(_ key: String, index: Int) {
		switch key {
		case "country":
			if self.masterData?.country?.isEmpty == false, let countryId = self.masterData?.country?[index].id {
				fetchMasterData(countryId: String(countryId))
				
				countryName = self.masterData?.country?[index].country
			}
			
		case "state":
			if self.masterData?.state?.isEmpty == false, let countryId = self.masterData?.state?[index].countryID, let stateId = self.masterData?.state?[index].id {
				fetchMasterData(countryId: String(countryId), stateId: String(stateId))
				
				stateName = self.masterData?.state?[index].state
			}
			
		case "cityID":
			if self.masterData?.city?.isEmpty == false, let cityId = self.masterData?.city?[index].id {
				self.addEventModel.cityID = String(cityId)
			}
		
		case "ageGroup":
			guard let eventDetails = eventDetails else { return }
			
			let filteredAgeGroups = self.masterData?.ageGroup?.filter({ (ageGroup) -> Bool in
				guard let ageGroupId = ageGroup.id, let minAgeGroupID = eventDetails.minAgeGroupID, let maxAgeGroupID = eventDetails.maxAgeGroupID else { return false }
				
				return ageGroupId >= minAgeGroupID && ageGroupId <= maxAgeGroupID
			})
			
			if let ageGroup = filteredAgeGroups?[index].id {
				addEventModel.ageGroup = String(ageGroup)
			}
			
		case "coachIsd":
			if let coachIsd = masterData?.country?[index].code {
				addEventModel.coachIsd = coachIsd
			}
			
		case "registerBy":
			if let registerBy = masterData?.registerBy?[index] {
				addEventModel.registerBy = String(registerBy.id ?? 0)
			}
			
		default:
			break
		}
		
		prepareFormData()
	}
	
	func footnoteButtonCallback(_ title: String) {
		
	}
	
	func toggleValueChanged(_ key: String, value: Bool) {
		if key == "isCoach" {
			addEventModel.isCoach = value
			
			prepareFormData()
		}
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case button(String)
	case toggle(ToggleViewModel)
}
