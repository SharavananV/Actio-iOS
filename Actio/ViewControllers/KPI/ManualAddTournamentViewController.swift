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
		self.navigationItem.rightBarButtonItem?.isEnabled = false
		
		self.fetchMasterData()
    }
	
	@objc func proceedTapped() {
		
	}
	
	func fetchMasterData() {
		service.post(nonActioMasterUrl, parameters: nil, onView: view) { [weak self] (response: NonActioMasterResponse) in
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
		
		registerModel?.events?.forEach({ (model) in
			formData.append(
				.addEvent(AddEventCellSettings(showDelete: true, allSports: self.masterData?.sports ?? [], model: model))
			)
		})
		
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
			
			dateCell.configure(model)
			cell = dateCell
			
		case .addEvent(let model):
			guard let eventCell = tableView.dequeueReusableCell(withIdentifier: AddEventTableViewCell.reuseId, for: indexPath) as? AddEventTableViewCell else {
				return UITableViewCell()
			}
			
			eventCell.configure(model)
			cell = eventCell
			
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let _ = tableView.cellForRow(at: indexPath) as? JustTextTableViewCell {
			registerModel?.events?.append(AddEventDetailsModel())
			
			prepareFormData()
		}
	}
}

extension ManualAddTournamentViewController: CellDataFetchProtocol, TextPickerDelegate {
	func valueChanged(keyValuePair: (key: String, value: String)) {
		
	}
	
	func didPickText(_ key: String, index: Int) {
		
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case fromToDate(FromToDatePickerModel)
	case addEvent(AddEventCellSettings)
	case justText(NSAttributedString)
}
