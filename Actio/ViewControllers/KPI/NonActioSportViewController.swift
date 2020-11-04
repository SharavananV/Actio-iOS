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
	private var registerModel: RegisterNonActioSportModel?
		
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.register(UserSelectionTableViewCell.self, forCellReuseIdentifier: UserSelectionTableViewCell.reuseId)
		tableView.separatorStyle = .none
		
		self.title = "Non Actio Sports"
		
        fetchMasterData()
    }
	
	func fetchMasterData() {
		service.post(nonActioMaster, parameters: nil, onView: view) { [weak self] (response: NonActioMasterResponse) in
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
		
		var formData: [FormCellType] = [
			.textPicker(TextPickerModel(key: "country", textValue: selectedCountry?.countryName, allValues: countries, contextText: "Country", placeHolder: "Select Country")),
			.textPicker(TextPickerModel(key: "state", textValue: selectedState?.stateName, allValues: states, contextText: "State", placeHolder: "Select State")),
			.textPicker(TextPickerModel(key: "year", textValue: String(registerModel?.year ?? 0), allValues: allYears, contextText: "Year", placeHolder: "Select Year"))
		]
		
		self.formData = formData
		
		UIView.setAnimationsEnabled(false)
		self.tableView.beginUpdates()
		self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
		self.tableView.endUpdates()
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
			
		case .searchPlayer:
			guard let playerCell = tableView.dequeueReusableCell(withIdentifier: UserSelectionTableViewCell.reuseId, for: indexPath) as? UserSelectionTableViewCell else {
				return UITableViewCell()
			}
			
			playerCell.delegate = self
			cell = playerCell
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
}

extension NonActioSportViewController: CellDataFetchProtocol, TextPickerDelegate, UserSelectionProtocol {
	func valueChanged(keyValuePair: (key: String, value: String)) {
		
	}
	
	func didPickText(_ key: String, index: Int) {
		
	}
	
	func reloadHeight() {
		
	}
	
	func playerList(forSearchText text: String, completion: @escaping ([SearchUserModel]) -> Void) {
		
	}
	
	func selectedPlayer(_ player: SearchUserModel) {
		
	}
	
	func resetData() {
		
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case searchPlayer
}
