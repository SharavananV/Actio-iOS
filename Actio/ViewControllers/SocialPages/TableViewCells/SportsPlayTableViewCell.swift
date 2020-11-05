//
//  SportsPlayTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit


class SportsPlayTableViewCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

	@IBOutlet var sportsPlayBackgroundView: UIView!
	@IBOutlet weak var practiceHoursTextField: UITextField!
    @IBOutlet weak var playerSinceTextField: UITextField!
    @IBOutlet weak var selectSportTextField: UITextField!
    static let reuseId = "SportsPlayTableViewCell"

    var sportArrayValues: [String]?
    var selectedSports: String?
    let pickerView = UIPickerView()

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
		sportsPlayBackgroundView.layer.cornerRadius = 5.0
		sportsPlayBackgroundView.layer.masksToBounds = true
        practiceHoursTextField.delegate = self
        playerSinceTextField.delegate = self
        selectSportTextField.delegate = self
        selectSportTextField.inputView = pickerView
    }
    var model : Play?
    
    func configure(_ play: Play?) {
        self.model = play
        selectSportTextField.text = play?.sportsName
        playerSinceTextField.text = String(play?.playingSince ?? 0)
        practiceHoursTextField.text = String(play?.weeklyHours ?? 0)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(self.selectSportTextField != nil && self.selectSportTextField == textField) {
            let sportTextValue = self.selectSportTextField?.text?.isEmpty == false ? self.selectSportTextField?.text : self.sportArrayValues?[0]
            selectSportTextField.text = sportTextValue
        }
        self.pickerView.reloadAllComponents()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  let value = selectSportTextField.text {
            self.model?.sportsName = value
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sportArrayValues?.count ?? 0
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sportArrayValues?[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSports = sportArrayValues?[row]
        selectSportTextField.text = selectedSports
    }
    

}
