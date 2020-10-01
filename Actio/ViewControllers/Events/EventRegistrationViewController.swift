//
//  EventRegistrationViewController.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventRegistrationViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	let service = DependencyProvider.shared.networkService
	var masterData: EventMaster?
	fileprivate var formData: [FormCellType]?
	let addEventModel = EventDetailsRegisterModel()
	var eventDetails: EventDetail?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
		tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
		
		self.title = "Event Registration"
		
        fetchMasterData()
    }
    
	private func fetchMasterData(countryId: String? = nil, stateId: String? = nil, sportsId: String? = nil) {
		let parameters = [ "countryID": countryId ?? "", "stateID": stateId ?? "", "sportsID": sportsId ?? ""]
		
		service.post(eventMasterUrl, parameters: parameters, onView: view) { (response: EventsMasterResponse) in
			self.masterData = response.master
			self.formData = self.prepareFormData()
			
			self.tableView.reloadData()
		}
	}
	
	private func prepareFormData() -> [FormCellType] {
		guard let eventDetails = self.eventDetails else { return [] }
		
		let registerBy = self.masterData?.registerBy?.map({
			$0.registerBy ?? ""
		}) ?? []
		
		let ageGroups = self.masterData?.ageGroup?.filter({ (ageGroup) -> Bool in
			
			print("ageGroup.id \(ageGroup.id ?? 0), eventDetails.minAgeGroupID \(eventDetails.minAgeGroupID ?? 0), eventDetails.maxAgeGroupID \(eventDetails.maxAgeGroupID ?? 0)")
			
			guard let ageGroupId = ageGroup.id, let minAgeGroupID = eventDetails.minAgeGroupID, let maxAgeGroupID = eventDetails.maxAgeGroupID else { return false }
			
			print("Result \(ageGroupId >= minAgeGroupID && ageGroupId <= maxAgeGroupID)")
			
			return ageGroupId >= minAgeGroupID && ageGroupId <= maxAgeGroupID
		}).map({ (group) -> String in
			return group.groupName ?? ""
		}) ?? []
		
		let isCoachString = NSAttributedString(string: "Do you want to include Coach Information", attributes: [.font : AppFont.PoppinsSemiBold(size: 14)])
		
		let formData: [FormCellType] = [
			.textPicker(TextPickerModel(key: "registerBy", textValue: nil, allValues: registerBy, contextText: "Registration By", placeHolder: "Select Register By")),
			.textEdit(TextEditModel(key: "registerAs", textValue: eventDetails.type, contextText: "Register As", enabled: false)),
			.textEdit(TextEditModel(key: "playerType", textValue: eventDetails.playerType, contextText: "Player Type", enabled: false)),
			.textPicker(TextPickerModel(key: "ageGroup", textValue: nil, allValues: ageGroups, contextText: "Age Group", placeHolder: "Select Age Group")),
			.textEdit(TextEditModel(key: "teamName", textValue: nil, contextText: "Team Name", placeHolder: "Team name allows a-z,0-9,_,.")),
			.toggle(ToggleViewModel(key: "isCoach", contextText: isCoachString))
			
		]
		
		return formData
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
		
	}
	
	func didPickText(_ key: String, index: Int) {
		
	}
	
	func footnoteButtonCallback(_ title: String) {
		
	}
	
	func toggleValueChanged(_ key: String, value: Bool) {
		
	}
}

// MARK: Core Data
extension EventRegistrationViewController {
	func addModelToCoreData() {
		let coreDataModel = EventRegistration(context: PersistentContainer.context)
		coreDataModel.ageGroup = addEventModel.ageGroup
		coreDataModel.cityID = addEventModel.cityID
		coreDataModel.coachEmail = addEventModel.coachEmail
		coreDataModel.coachIsd = addEventModel.coachIsd
		coreDataModel.coachMobile = addEventModel.coachMobile
		coreDataModel.coachName = addEventModel.coachName
		coreDataModel.eventID = addEventModel.eventID
		coreDataModel.isCoach = addEventModel.isCoach ?? false
		coreDataModel.registerBy = addEventModel.registerBy
		coreDataModel.registrationID = addEventModel.registrationID
		coreDataModel.teamName = addEventModel.teamName
		
		PersistentContainer.saveContext()
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case button(String)
	case toggle(ToggleViewModel)
}
