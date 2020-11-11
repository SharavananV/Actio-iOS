//
//  NonActioSportViewController.swift
//  Actio
//
//  Created by KnilaDev on 04/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class NonActioSportViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var formData: [FormCellType]?
	private var masterData: NonActioMaster?
	private var filterData: NonActioFilter?
	private var registerModel: RegisterKPIModel? = RegisterKPIModel()
		
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.register(UserSelectionTableViewCell.self, forCellReuseIdentifier: UserSelectionTableViewCell.reuseId)
		tableView.register(JustTextTableViewCell.self, forCellReuseIdentifier: JustTextTableViewCell.reuseId)
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
		
		self.title = "Non Actio Sports"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(self.proceedTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
		self.navigationItem.rightBarButtonItem?.isEnabled = false
		
        fetchMasterData()
    }
	
	@objc func proceedTapped() {
		let validationResult = registerModel?.validate()
		switch validationResult {
		case .invalid(let message):
			view.makeToast(message)
			return
			
		case .valid, .none:
			break
		}
		
		service.post(registerNonActioKpiUrl, parameters: registerModel?.parameters(), onView: view) { (response) in
			if let message = response["msg"] as? String {
				self.view.makeToast(message) { _ in
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
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
		
		let allYears = self.filterData?.years?.map({ String($0) }) ?? []
		let selectedYear = registerModel?.year == nil ? "" : String(registerModel?.year ?? 0)
		
		let allTournaments = self.filterData?.tournaments?.compactMap({ $0.tournamentName }) ?? []
		let selectedTournament = self.filterData?.tournaments?.first(where: {
			$0.tournamentID == self.registerModel?.tournamentID
		})?.tournamentName ?? ""
		
		let allEvents = self.filterData?.events?.compactMap({ $0.eventName }) ?? []
		let selectedEvent = self.filterData?.events?.first(where: {
			$0.eventID == self.registerModel?.eventID
		})?.eventName ?? ""
		
		let addTournamentText = NSMutableAttributedString(string:"+ Add tournament manually", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 17), NSAttributedString.Key.foregroundColor : AppColor.OrangeColor()])
		
		var formData: [FormCellType] = [
			.textPicker(TextPickerModel(key: "country", textValue: selectedCountry?.countryName, allValues: countries, contextText: "Country", placeHolder: "Select Country", actioField: false)),
			.textPicker(TextPickerModel(key: "state", textValue: selectedState?.stateName, allValues: states, contextText: "State", placeHolder: "Select State", actioField: false)),
			.textPicker(TextPickerModel(key: "year", textValue: selectedYear, allValues: allYears, contextText: "Year", placeHolder: "Select Year", actioField: false)),
			.textPicker(TextPickerModel(key: "tournament", textValue: selectedTournament, allValues: allTournaments, contextText: "Tournament", placeHolder: "Select Tournament", actioField: false)),
			.attrText(addTournamentText, .center),
			.textPicker(TextPickerModel(key: "event", textValue: selectedEvent, allValues: allEvents, contextText: "Event", placeHolder: "Select Event", actioField: false)),
			.searchPlayer(UserSearchSettings(showReset: false, showUserName: true, retainResult: false, collapseTableViewOnSelection: false, title: "Search by Coach", placeHolder: "Search By Username, Subscription ID or Mobile No"))
		]
		
		if registerModel?.coachID != nil {
			formData.append(
				.text(registerModel?.coachName ?? "", .natural, true)
			)
		}
		
		self.filterData?.kpi?.forEach({ (kpiModel) in
			let kpiIDString = String(kpiModel.kpiID ?? 0)
			let textValue = registerModel?.kpi[kpiIDString]
			let keyboardType: UIKeyboardType = kpiModel.kpiType == 2 ? .numberPad : .default
			formData.append(
				.textEdit(TextEditModel(key: kpiIDString, textValue: textValue, contextText: kpiModel.kpiName ?? "", placeHolder: "", keyboardType: keyboardType, actioField: false))
			)
			
			if self.registerModel?.kpi.isEmpty == true {
				self.registerModel?.kpi[kpiIDString] = ""
				self.registerModel?.kpiText[kpiIDString] = kpiModel.kpiName
			}
		})
		
		if filterData?.kpi?.isEmpty == false {
			navigationItem.rightBarButtonItem?.isEnabled = true
		}
		
		self.formData = formData
		
		tableView.reloadData()
	}
}

extension NonActioSportViewController: UITableViewDataSource, UITableViewDelegate {
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
			
		case .searchPlayer(let model):
			guard let playerCell = tableView.dequeueReusableCell(withIdentifier: UserSelectionTableViewCell.reuseId, for: indexPath) as? UserSelectionTableViewCell else {
				return UITableViewCell()
			}
			
			playerCell.delegate = self
			playerCell.configure(settings: model)
			cell = playerCell
			
		case .attrText(let text, let alignment):
			guard let textCell = tableView.dequeueReusableCell(withIdentifier: JustTextTableViewCell.reuseId, for: indexPath) as? JustTextTableViewCell else {
				return UITableViewCell()
			}
			
			textCell.configure(nil, text, alignment: alignment)
			cell = textCell
			
		case .text(let text, let alignment, let useLine):
			guard let textCell = tableView.dequeueReusableCell(withIdentifier: JustTextTableViewCell.reuseId, for: indexPath) as? JustTextTableViewCell else {
				return UITableViewCell()
			}
			
			textCell.configure(text, nil, alignment: alignment, useLine)
			cell = textCell
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let _ = tableView.cellForRow(at: indexPath) as? JustTextTableViewCell,
		   let vc = storyboard?.instantiateViewController(withIdentifier: "ManualAddTournamentViewController") as? ManualAddTournamentViewController {
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}

extension NonActioSportViewController: CellDataFetchProtocol, TextPickerDelegate, UserSelectionProtocol {
	func valueChanged(keyValuePair: (key: String, value: String)) {
		self.registerModel?.kpi[keyValuePair.key] = keyValuePair.value
		prepareFormData()
	}
	
	func didPickText(_ key: String, index: Int) {
		switch key {
		case "country":
			registerModel?.country = self.masterData?.countryState?[index].countryID
			registerModel?.state = nil
			registerModel?.year = nil
			filterData = nil
			prepareFormData()
			
		case "state":
			let selectedCountry = self.masterData?.countryState?.first(where: {
				$0.countryID == self.registerModel?.country
			})
			registerModel?.state = selectedCountry?.states?[index].stateID
			registerModel?.year = nil
			updateMasterData()
			
		case "year":
			registerModel?.year = self.filterData?.years?[index]
			updateMasterData()
			
		case "tournament":
			registerModel?.tournamentID = self.filterData?.tournaments?[index].tournamentID
			updateMasterData()
			
		case "event":
			registerModel?.eventID = self.filterData?.events?[index].eventID
			updateMasterData()
			
		default:
			break
		}
	}
	
	func reloadHeight() {
		tableView.beginUpdates()
		tableView.endUpdates()
		
		let bottomIndex = IndexPath(row: self.tableView.numberOfRows(inSection: 0)-1, section: 0)
		tableView.scrollToRow(at: bottomIndex, at: .bottom, animated: false)
	}
	
	func playerList(forSearchText text: String, completion: @escaping ([SearchUserModel]) -> Void) {
		service.post(searchCoachUrl, parameters: ["search_string": text.lowercased()], onView: view) { (response: SearchPlayerResponse) in
			completion(response.result ?? [])
		}
	}
	
	func selectedPlayer(_ player: SearchUserModel) {
		self.registerModel?.coachID = player.subscriberDisplayID?.value
		self.registerModel?.coachName = player.fullName
		
		prepareFormData()
	}
	
	func resetData() {
		
	}
	
	func updateMasterData() {
		let params: [String : Any] = [
			"country": registerModel?.country ?? "",
			"state": registerModel?.state ?? "",
			"year": registerModel?.year ?? "",
			"tournamentID": registerModel?.tournamentID ?? "",
			"eventID": registerModel?.eventID ?? ""
		]
		
		service.post(nonActioFilterUrl, parameters: params, onView: view) { (response: NonActioFilterResponse) in
			self.filterData = response.result
			
			self.prepareFormData()
		}
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case searchPlayer(UserSearchSettings)
	case attrText(NSAttributedString, NSTextAlignment)
	case text(String, NSTextAlignment, Bool)
}
