//
//  SportsPlayTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol SportInfoDeleteProtocol: class {
	func sportDeleted(_ data: Play?)
}

class SportsPlayTableViewCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

	@IBOutlet var sportsPlayBackgroundView: UIView!
	@IBOutlet weak var practiceHoursTextField: UITextField!
    @IBOutlet weak var playerSinceTextField: UITextField!
    @IBOutlet weak var selectSportTextField: UITextField!
	@IBOutlet var deleteButtonAction: UIButton!
	static let reuseId = "SportsPlayTableViewCell"

    private var allSports: [Sport]?
    private var selectedSports: Sport?
    let pickerView = UIPickerView()
	weak var delegate: SportInfoDeleteProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
		sportsPlayBackgroundView.layer.cornerRadius = 5.0
		sportsPlayBackgroundView.layer.masksToBounds = true
        practiceHoursTextField.delegate = self
        playerSinceTextField.delegate = self
        selectSportTextField.delegate = self
		
		playerSinceTextField.keyboardType = .numberPad
		practiceHoursTextField.keyboardType = .numberPad
		
        selectSportTextField.inputView = pickerView
    }
    var model : Play?
    
	func configure(_ play: Play?, allSports: [Sport]?, showDelete: Bool = false) {
        self.model = play
		self.allSports = allSports
		
        selectSportTextField.text = play?.sportsName
        playerSinceTextField.text = String(play?.playingSince ?? 0)
        practiceHoursTextField.text = String(play?.weeklyHours ?? 0)
		deleteButtonAction.isHidden = showDelete == false
		
		pickerView.reloadAllComponents()
    }
	
	@IBAction func deleteButtonAction(_ sender: Any) {
		delegate?.sportDeleted(self.model)
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if allSports?.isEmpty == false, self.selectSportTextField != nil && self.selectSportTextField == textField {
			let sportTextValue = self.selectSportTextField?.text?.isEmpty == false ? self.selectSportTextField?.text : self.allSports?.first?.sports
            selectSportTextField.text = sportTextValue
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
		switch textField {
		case self.selectSportTextField:
			let selectedSport = allSports?.first { $0.sports == textField.text }
			self.model?.sportsID = selectedSport?.id
			self.model?.sportsName = textField.text
		case self.playerSinceTextField:
			self.model?.playingSince = Int(textField.text ?? "0")
		case self.practiceHoursTextField:
			self.model?.weeklyHours = Int(textField.text ?? "0")
		default:
			break
		}
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allSports?.count ?? 0
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return allSports?[row].sports
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSports = allSports?[row]
		selectSportTextField.text = selectedSports?.sports
    }
    

}
