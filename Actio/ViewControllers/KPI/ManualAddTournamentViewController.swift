//
//  ManualAddTournamentViewController.swift
//  Actio
//
//  Created by KnilaDev on 05/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ManualAddTournamentViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var formData: [FormCellType]?
	private var masterData: NonActioMaster?
	private var registerModel: RegisterNewTournamentModel? = RegisterNewTournamentModel()
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(FromToDatePickerTableViewCell.self, forCellReuseIdentifier: FromToDatePickerTableViewCell.reuseId)
		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.register(JustTextTableViewCell.self, forCellReuseIdentifier: JustTextTableViewCell.reuseId)
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
		
		self.title = "Add Tournament"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(self.proceedTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
		
		self.fetchMasterData()
    }
	
	@objc func proceedTapped() {
		view.endEditing(true)
		
		let validationResult = registerModel?.validate()
		switch validationResult {
		case .invalid(let message):
			view.makeToast(message)
			return
			
		case .valid, .none:
			break
		}
		
		service.post(registerManualTournamentUrl, parameters: self.registerModel?.parameters(), onView: view) { (response) in
			if let message = response["msg"] as? String {
				self.view.makeToast(message) { _ in
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
	
	func fetchMasterData() {
		service.post(nonActioMasterUrl, parameters: nil, onView: view, shouldDismissOnError: true) { [weak self] (response: NonActioMasterResponse) in
			self?.masterData = response.result
			
			self?.prepareFormData()
		}
	}
	
	private func prepareFormData() {
		let countries = self.masterData?.countryState?.compactMap({ $0.countryName }) ?? []
		let selectedCountry = self.masterData?.countryState?.first(where: {
			$0.countryID == self.registerModel?.country
		})
		
		let states = selectedCountry?.states?.compactMap({ $0.stateName }) ?? []
		let selectedState = selectedCountry?.states?.first(where: {
			$0.stateID == self.registerModel?.state
		})
		
		let allYears = self.masterData?.years?.map({ String($0) }) ?? []
		let selectedYear = registerModel?.year == nil ? "" : String(registerModel?.year ?? 0)
		
		let addEventText = NSMutableAttributedString(string:"+ Add more event", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 17), NSAttributedString.Key.foregroundColor : AppColor.OrangeColor()])
		
		var formData: [FormCellType] = [
			.textPicker(TextPickerModel(key: "country", textValue: selectedCountry?.countryName, allValues: countries, contextText: "Country", placeHolder: "Select Country")),
			.textPicker(TextPickerModel(key: "state", textValue: selectedState?.stateName, allValues: states, contextText: "State", placeHolder: "Select State")),
			.textPicker(TextPickerModel(key: "year", textValue: selectedYear, allValues: allYears, contextText: "Year", placeHolder: "Select Year")),
			.textEdit(TextEditModel(key: "tournamentName", textValue: registerModel?.tournamentName, contextText: "Tournament Name" , placeHolder: "")),
			.fromToDate(FromToDatePickerModel(fromKey: "from", toKey: "to", minDate: nil, maxDate: Date(), fromDate: registerModel?.fromDate?.toDate, toDate: registerModel?.toDate?.toDate, isEnabled: true)),
			.textEdit(TextEditModel(key: "venue", textValue: registerModel?.venue, contextText: "Venue" , placeHolder: "")),
			.justText(addEventText)
		]
		
		if let events = registerModel?.events, events.isEmpty == true {
			registerModel?.events?.append(AddEventDetailsModel())
		}
		
		for index in 0..<(registerModel?.events ?? []).count {
			let model = registerModel?.events?[index] ?? AddEventDetailsModel()
			formData.append(
				.addEvent(AddEventCellSettings(showDelete: true, allSports: self.masterData?.sports ?? [], model: model), index)
			)
		}
		
		self.formData = formData
		
		tableView.reloadData()
	}
}

extension ManualAddTournamentViewController: UITableViewDataSource, UITableViewDelegate {
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
			
		case .justText(let text):
			guard let textCell = tableView.dequeueReusableCell(withIdentifier: JustTextTableViewCell.reuseId, for: indexPath) as? JustTextTableViewCell else {
				return UITableViewCell()
			}
			
			textCell.configure(nil, text, alignment: .center)
			cell = textCell
			
		case .fromToDate(let model):
			guard let dateCell = tableView.dequeueReusableCell(withIdentifier: FromToDatePickerTableViewCell.reuseId, for: indexPath) as? FromToDatePickerTableViewCell else {
				return UITableViewCell()
			}
			
			dateCell.delegate = self
			dateCell.configure(model)
			cell = dateCell
			
		case .addEvent(let model, let index):
			guard let eventCell = tableView.dequeueReusableCell(withIdentifier: AddEventTableViewCell.reuseId, for: indexPath) as? AddEventTableViewCell else {
				return UITableViewCell()
			}
			
			eventCell.configure(model, index)
			eventCell.delegate = self
			cell = eventCell
			
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let events = registerModel?.events, let _ = tableView.cellForRow(at: indexPath) as? JustTextTableViewCell {
			view.endEditing(true)
			
			for model in events {
				if model.name == nil {
					view.makeToast("Enter event value")
					return
				}
				if model.sports == nil {
					view.makeToast("Select Sport")
					return
				}
			}
			registerModel?.events?.append(AddEventDetailsModel())
			
			prepareFormData()
		}
	}
}

extension ManualAddTournamentViewController: CellDataFetchProtocol, TextPickerDelegate, AddEventProtocol {
	func valueChanged(keyValuePair: (key: String, value: String)) {
		switch keyValuePair.key {
		case "tournamentName":
			registerModel?.tournamentName = keyValuePair.value
		case "venue":
			registerModel?.venue = keyValuePair.value
		case "from":
			registerModel?.fromDate = keyValuePair.value
		case "to":
			registerModel?.toDate = keyValuePair.value
		default:
			break
		}
	}
	
	func didPickText(_ key: String, index: Int) {
		switch key {
		case "country":
			registerModel?.country = masterData?.countryState?[index].countryID
			registerModel?.state = nil
			registerModel?.year = nil
		
		case "state":
			let selectedCountry = self.masterData?.countryState?.first(where: {
				$0.countryID == self.registerModel?.country
			})
			registerModel?.state = selectedCountry?.states?[index].stateID
			registerModel?.year = nil
			
		case "year":
			registerModel?.year = self.masterData?.years?[index]
			prepareFormData()
			
		default:
			return
		}
		
		prepareFormData()
	}
	
	func deleteTapped(_ index: Int) {
		registerModel?.events?.remove(at: index)
		
		prepareFormData()
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case fromToDate(FromToDatePickerModel)
	case addEvent(AddEventCellSettings, Int)
	case justText(NSAttributedString)
}
