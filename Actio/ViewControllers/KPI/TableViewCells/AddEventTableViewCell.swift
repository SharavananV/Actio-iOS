//
//  AddEventTableViewCell.swift
//  Actio
//
//  Created by KnilaDev on 05/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol AddEventProtocol: class {
	func deleteTapped()
}

class AddEventTableViewCell: UITableViewCell {
	
	static let reuseId = "AddEventTableViewCell"
	
	@IBOutlet var shadowContainer: UIView!
	@IBOutlet var deleteButton: UIButton!
	@IBOutlet var eventNameField: UITextField!
	@IBOutlet var sportNameField: UITextField!
	
	weak var delegate: AddEventProtocol?
	private var model: AddEventCellSettings?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
		shadowContainer.layer.cornerRadius = 10
		shadowContainer.layer.masksToBounds = true
		
		shadowContainer.layer.shadowColor = UIColor.lightGray.cgColor
		shadowContainer.layer.shadowOpacity = 0.5
		shadowContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
		shadowContainer.layer.shadowRadius = 3
		shadowContainer.layer.masksToBounds = false
    }
	
	private lazy var textPicker: UIPickerView = {
		let textPicker = UIPickerView()
		textPicker.dataSource = self
		textPicker.delegate = self
		
		return textPicker
	}()
	
	private func setupToolBar() {
		self.sportNameField.inputView = textPicker
	}
	
	func configure(_ data: AddEventCellSettings) {
		setupToolBar()
		
		eventNameField.text = data.model.name
		sportNameField.text = data.model.sportsName
		
		self.model = data
	}

	@IBAction func deleteButtonTapped(_ sender: Any) {
		
	}
}

extension AddEventTableViewCell: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == sportNameField, self.model?.allSports.count == 0 { return }
		
		let timeValue = self.model?.model.sportsName?.isEmpty == false ? self.model?.model.sportsName : self.model?.allSports[0].sportsName
		textField.text = timeValue
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == eventNameField {
			self.model?.model.name = textField.text
		}
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.model?.allSports.count ?? 0
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.model?.allSports[row].sportsName
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if let sport = self.model?.allSports[row] {
			self.sportNameField.text = sport.sportsName
			self.model?.model.sportsName = sport.sportsName
			self.model?.model.sports = sport.id
		}
	}
}

class AddEventCellSettings {
	internal init(showDelete: Bool, allSports: [TournamentSport], model: AddEventDetailsModel) {
		self.showDelete = showDelete
		self.allSports = allSports
		self.model = model
	}
	
	var showDelete: Bool
	var allSports: [TournamentSport]
	var model: AddEventDetailsModel
}

class AddEventDetailsModel {
	var sports: Int?
	var name: String?
	var sportsName: String?
}
