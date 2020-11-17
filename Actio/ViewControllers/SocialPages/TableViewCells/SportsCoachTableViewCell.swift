//
//  SportsCoachTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol CoachInfoDeleteProtocol: class {
	func coachDeleted(_ data: Coaching?)
}

class SportsCoachTableViewCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
	static let reuseId = "SportsCoachTableViewCell"
	
	@IBOutlet var sportsCoachBackgroundView: UIView!
	@IBOutlet weak var coachSelectSportTextField: UITextField!
    @IBOutlet weak var aboutCoachingTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
	@IBOutlet var deleteButton: UIButton!
	
    var allSports: [Sport]?
    var stateCityValues : [StateCity]?
	var allCities: [MasterCity]? {
		self.selectedState?.city
	}
    let pickerView = UIPickerView()
	var model: Coaching?
	weak var delegate: CoachInfoDeleteProtocol?
	
	private var selectedState: StateCity?

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
	
	func configure(_ coach: Coaching?, allSports: [Sport]?, allStateCities: [StateCity]?, showDelete: Bool = false) {
		self.coachSelectSportTextField.text = coach?.sportsName
		self.cityTextField.text = coach?.cityName
		self.stateTextField.text = coach?.stateName
		self.localityTextField.text = coach?.locality
		self.aboutCoachingTextField.text = coach?.remarks
		
		self.model = coach
		self.allSports = allSports
		self.stateCityValues = allStateCities
		self.deleteButton.isHidden = showDelete == false
	}
	
	@IBAction func deleteButtonAction(_ sender: Any) {
		delegate?.coachDeleted(self.model)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		switch textField {
		case self.coachSelectSportTextField:
			let selectedSport = allSports?.first { $0.sports == textField.text }
			self.model?.sportsID = selectedSport?.id
			self.model?.sportsName = selectedSport?.sports
			
		case self.cityTextField:
			let selectedCity = selectedState?.city?.first { $0.cityName == textField.text }
			self.model?.cityID = selectedCity?.cityId
			self.model?.cityName = selectedCity?.cityName
			
		case self.stateTextField:
			self.model?.stateID = self.selectedState?.stateID
			self.model?.stateName = self.selectedState?.stateName
			
		case self.localityTextField:
			self.model?.locality = textField.text
			
		case self.aboutCoachingTextField:
			self.model?.remarks = textField.text
			
		default:
			break
		}
	}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
		if self.coachSelectSportTextField == textField && allSports?.isEmpty == false {
			let sportTextValue = self.coachSelectSportTextField?.text?.isEmpty == false ? self.coachSelectSportTextField?.text : self.allSports?.first?.sports
			coachSelectSportTextField.text = sportTextValue
		}
		
		if self.stateTextField == textField, stateCityValues?.isEmpty == false {
			let stateTextValue = self.stateTextField?.text?.isEmpty == false ? self.stateTextField?.text : stateCityValues?.first?.stateName
			self.selectedState = stateCityValues?.first
			stateTextField.text = stateTextValue
		}
		
		if self.cityTextField == textField, let stateValue = self.selectedState, let allCities = stateValue.city, allCities.isEmpty == false {
			let cityValue = self.cityTextField?.text?.isEmpty == false ? self.cityTextField?.text : allCities.first?.cityName
			self.cityTextField.text = cityValue
		}
		
		pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if cityTextField.isFirstResponder{
            return allCities?.count ?? 0
        } else if coachSelectSportTextField.isFirstResponder{
            return allSports?.count ?? 0
        } else if stateTextField.isFirstResponder{
            return stateCityValues?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if cityTextField.isFirstResponder{
            let itemselected = allCities?[row]
			cityTextField.text = itemselected?.cityName
        }else if coachSelectSportTextField.isFirstResponder{
			let itemselected = allSports?[row].sports
            coachSelectSportTextField.text = itemselected
        }else if stateTextField.isFirstResponder{
			let itemselected = stateCityValues?[row].stateName
			self.selectedState = stateCityValues?[row]
            stateTextField.text = itemselected
			cityTextField.text = nil
			model?.cityID = nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if cityTextField.isFirstResponder {
			return allCities?[row].cityName
        } else if stateTextField.isFirstResponder {
			return stateCityValues?[row].stateName
        } else if coachSelectSportTextField.isFirstResponder {
			return allSports?[row].sports
        }
        return nil
    }


}
