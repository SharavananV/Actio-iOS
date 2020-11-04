//
//  SportsCoachTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class SportsCoachTableViewCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
	@IBOutlet var sportsCoachBackgroundView: UIView!
	@IBOutlet weak var coachSelectSportTextField: UITextField!
    @IBOutlet weak var aboutCoachingTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    static let reuseId = "SportsCoachTableViewCell"
    
    var sportArrayValues: [String]?
    var cityArrayValues: [String]?
    var stateArrayValues : [String]?
    let pickerView = UIPickerView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
		sportsCoachBackgroundView.layer.cornerRadius = 5.0
		sportsCoachBackgroundView.layer.masksToBounds = true
        coachSelectSportTextField.delegate = self
        aboutCoachingTextField.delegate = self
        localityTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        coachSelectSportTextField.inputView = pickerView
        cityTextField.inputView = pickerView
        stateTextField.inputView = pickerView
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (self.cityTextField != nil && self.cityTextField == textField) {
            //let cityValue = self.cityTextField?.text?.isEmpty == false ? self.cityTextField?.text : self.cityArrayValues?[0]
           // cityTextField.text = cityValue
        } else if(self.coachSelectSportTextField != nil && self.coachSelectSportTextField == textField) {
            let sportTextValue = self.coachSelectSportTextField?.text?.isEmpty == false ? self.coachSelectSportTextField?.text : self.sportArrayValues?[0]
            coachSelectSportTextField.text = sportTextValue
        }else if(self.stateTextField != nil && self.stateTextField == textField) {
            let stateTextValue = self.stateTextField?.text?.isEmpty == false ? self.stateTextField?.text : self.stateArrayValues?[0]
            stateTextField.text = stateTextValue
        }
        self.pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if cityTextField.isFirstResponder{
            return cityArrayValues?.count ?? 0
        }else if coachSelectSportTextField.isFirstResponder{
            return sportArrayValues?.count ?? 0
        }else if stateTextField.isFirstResponder{
            return stateArrayValues?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if cityTextField.isFirstResponder{
            let itemselected = cityArrayValues?[row]
            cityTextField.text = itemselected
        }else if coachSelectSportTextField.isFirstResponder{
            let itemselected = sportArrayValues?[row]
            coachSelectSportTextField.text = itemselected
        }else if stateTextField.isFirstResponder{
            let itemselected = stateArrayValues?[row]
            stateTextField.text = itemselected
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if cityTextField.isFirstResponder{
            return cityArrayValues?[row]
        }else if coachSelectSportTextField.isFirstResponder{
            return sportArrayValues?[row]
        }else if stateTextField.isFirstResponder{
            return stateArrayValues?[row]
        }
        return nil
    }


}
