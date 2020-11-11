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
	var updateEventDetails: ActioEvent? {
		didSet {
			if let details = self.updateEventDetails {
				self.kpiEventDetails = KPIEvent(details)
				self.kpiEventDetails?.kpi = details.eventKpi?.map({ (model) -> KpiFilterModel in
					return KpiFilterModel(kpiID: model.kpiCategoryID, kpiName: model.kpiCategoryName, kpiType: model.typeStatus)
				})
				
				self.registerModel?.kpiID = details.kpiID
				self.registerModel?.kpiType = details.eventKpiType
				
				details.eventKpi?.forEach({ (model) in
					if let value = model.kpiCategoryValue {
						let key = String(model.kpiCategoryID ?? 0)
						self.registerModel?.kpi[key] = value
					}
				})
			}
		}
	}
	var fromScreen: FromController = .submit
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(TwoLabelTableViewCell.self, forCellReuseIdentifier: TwoLabelTableViewCell.reuseId)
		tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
		
		self.title = "Actio Event Details"
		let titleText = fromScreen == .submit ? "Submit" : "Update"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: titleText, style: .done, target: self, action: #selector(self.proceedTapped))
		self.navigationItem.rightBarButtonItem?.tintColor = .white
		
		if fromScreen == .update {
			prepareFormData()
		} else {
			fetchDetails()
		}
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
		
		let validationResult = fromScreen == .submit ? registerModel?.validateForActioKpi() : registerModel?.validateForUpdateKpi()
		switch validationResult {
		case .invalid(let message):
			view.makeToast(message)
			return
			
		case .valid, .none:
			break
		}
		
		let serviceUrl = fromScreen == .submit ? submitActioKpi : updateActioKpi
		let params: [String: Any]? = fromScreen == .submit ? registerModel?.parameters() : registerModel?.updateParams()
		
		service.post(serviceUrl, parameters: params, onView: view) { (response) in
			if let message = response["msg"] as? String {
				self.view.makeToast(message) { _ in
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
	
	private func prepareFormData() {
		let allCoaches = kpiEventDetails?.coachList?.map({ $0.coachName ?? "" }) ?? []
		let selectedCoach = fromScreen == .submit ? registerModel?.coachName: kpiEventDetails?.selectedCoach
		var formData: [FormCellType] = [
			.info("Tournament", kpiEventDetails?.tournamentName),
			.info("Event", kpiEventDetails?.eventName),
			.info("Date", kpiEventDetails?.eventDateRange),
			.info("Venue", kpiEventDetails?.venueName),
			.textPicker(TextPickerModel(key: "coach", textValue: selectedCoach, allValues: allCoaches, contextText: "Coach", placeHolder: "Select Coach", isEnabled: fromScreen == .submit))
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
	
	enum FromController {
		case submit, update
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case info(String?, String?)
}
