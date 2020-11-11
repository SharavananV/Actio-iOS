//
//  ActioEventKPIViewController.swift
//  Actio
//
//  Created by KnilaDev on 10/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ActioEventKPIViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var formData: [FormCellType]?
	private var kpiEventDetails: KPIEvent?
	private var registerModel: RegisterKPIModel? = RegisterKPIModel()
	
	var eventId: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(TwoLabelTableViewCell.self, forCellReuseIdentifier: TwoLabelTableViewCell.reuseId)
		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
		
		self.title = "Actio Event Details"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(self.proceedTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
		
		fetchDetails()
	}
	
	private func fetchDetails() {
		guard let eventId = self.eventId else { return }
		
		service.post(actioKPIUrl, parameters: ["eventID": eventId], onView: view) { (response: ActioKPIResponse) in
			self.kpiEventDetails = response.event
			self.registerModel?.eventID = eventId
			self.registerModel?.tournamentID = self.kpiEventDetails?.tournamentID
			
			self.prepareFormData()
		}
	}
	
	@objc func proceedTapped() {
		view.endEditing(true)
		
		let validationResult = registerModel?.validateForActioKpi()
		switch validationResult {
		case .invalid(let message):
			view.makeToast(message)
			return
			
		case .valid, .none:
			break
		}
		
		service.post(submitActioKpi, parameters: registerModel?.parameters(), onView: view) { (response) in
			if let message = response["msg"] as? String {
				self.view.makeToast(message) { _ in
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
	
	private func prepareFormData() {
		let allCoaches = kpiEventDetails?.coachList?.map({ $0.coachName ?? "" }) ?? []
		
		var formData: [FormCellType] = [
			.info("Tournament", kpiEventDetails?.tournamentName),
			.info("Event", kpiEventDetails?.eventName),
			.info("Date", kpiEventDetails?.eventDateRange),
			.info("Venue", kpiEventDetails?.venueName),
			.textPicker(TextPickerModel(key: "coach", textValue: registerModel?.coachName, allValues: allCoaches, contextText: "Coach", placeHolder: "Select Coach"))
		]
		
		self.kpiEventDetails?.kpi?.forEach({ (kpiModel) in
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
		
		self.formData = formData

		tableView.reloadData()
	}
}

extension ActioEventKPIViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return formData?.count ?? 0
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
			
		case .info(let key, let value):
			guard let infoCell = tableView.dequeueReusableCell(withIdentifier: TwoLabelTableViewCell.reuseId, for: indexPath) as? TwoLabelTableViewCell else {
				return UITableViewCell()
			}
			
			infoCell.configure(key, rightText: value)
			cell = infoCell
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
}

extension ActioEventKPIViewController: TextPickerDelegate, CellDataFetchProtocol {
	func didPickText(_ key: String, index: Int) {
		switch key {
		case "coach":
			let coachDetails = kpiEventDetails?.coachList?[index]
			self.registerModel?.coachID = coachDetails?.id
			self.registerModel?.coachName = coachDetails?.coachName
			
		default:
			break
		}
		
		prepareFormData()
	}
	
	func valueChanged(keyValuePair: (key: String, value: String)) {
		self.registerModel?.kpi[keyValuePair.key] = keyValuePair.value
		prepareFormData()
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case info(String?, String?)
}
