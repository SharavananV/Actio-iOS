//
//  TournamentFilterViewController.swift
//  Actio
//
//  Created by apple on 07/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import CoreLocation

protocol filterValueDelegate: class {
    func FilterdValues(parameters:[String:Any])
}

class TournamentFilterViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var priceMaxValueLabel: UILabel!
    @IBOutlet weak var priceMinValueLabel: UILabel!
    @IBOutlet weak var eventSportTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tournamentTypeTextField: UITextField!
    @IBOutlet weak var rangeSlider: RangeSlider!

    @IBOutlet weak var below5Button: UIButton!
    @IBOutlet weak var below10Button: UIButton!
    @IBOutlet weak var below15Button: UIButton!
    @IBOutlet weak var below20Button: UIButton!
    @IBOutlet weak var below30Button: UIButton!
    
    let cityButton = UIButton(type: .custom)
    let typeButton = UIButton(type: .custom)
    let categoryButton = UIButton(type: .custom)
    let sportButton = UIButton(type: .custom)
    weak var delegate: filterValueDelegate?


    private let service = DependencyProvider.shared.networkService
    var masterDetails: TournamentMaster?
    var locationManager: CLLocationManager = CLLocationManager()
    var currentCoordinates : CLLocationCoordinate2D?
    var tournamentListModel : TournamentListModel?

    weak var pickerView: UIPickerView?
    
    var cityArrayValues: [String]?
    var typeArrayValues : [String]?
    var categoryArrayValues : [String]?
    var sportArrayValues : [String]?
    var clickedButtonTitle : String?
    var cityArrayId: [String]?



    @IBAction func priceValueAction(_ sender: RangeSlider) {
        let lowervalue = Int(rangeSlider.lowerValue)
        let upperValue = Int(rangeSlider.upperValue)
        
        self.priceMinValueLabel.text = String(lowervalue)
        self.priceMaxValueLabel.text = String(upperValue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeSlider.upperValue = 10000
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(applyFilterAction)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem

        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        textfielDropDownlist()
        rangeSlider.trackHighlightTintColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
        rangeSlider.trackTintColor = #colorLiteral(red: 0.9882352941, green: 0.9411764706, blue: 0.9176470588, alpha: 1)
        cityTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        eventSportTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        categoryTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        tournamentTypeTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        buttonCornerRadius()
        getTournamentMasterDetails()
        textFieldPickerView()
    }
    @objc func applyFilterAction(){
        applyFilterListCall()

    }
    
    func textfielDropDownlist() {
        
        self.cityButton.setImage(UIImage(named: "down"), for: .normal)
        cityButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        cityButton.frame = CGRect(x: CGFloat(self.cityTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        cityButton.addTarget(self, action: #selector(cityDropDownClickAction), for: .touchUpInside)
        cityTextField.rightView = cityButton
        cityTextField.rightViewMode = .always
        
        self.typeButton.setImage(UIImage(named: "down"), for: .normal)
        typeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        typeButton.frame = CGRect(x: CGFloat(self.cityTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        typeButton.addTarget(self, action: #selector(typeDropDownClickAction), for: .touchUpInside)
        tournamentTypeTextField.rightView = typeButton
        tournamentTypeTextField.rightViewMode = .always
        
        self.categoryButton.setImage(UIImage(named: "down"), for: .normal)
        categoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        categoryButton.frame = CGRect(x: CGFloat(self.cityTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        categoryButton.addTarget(self, action: #selector(categoryDropDownClickAction), for: .touchUpInside)
        categoryTextField.rightView = categoryButton
        categoryTextField.rightViewMode = .always

        self.sportButton.setImage(UIImage(named: "down"), for: .normal)
        sportButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        sportButton.frame = CGRect(x: CGFloat(self.cityTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        sportButton.addTarget(self, action: #selector(sportDropDownClickAction), for: .touchUpInside)
        eventSportTextField.rightView = sportButton
        eventSportTextField.rightViewMode = .always
    }
    
    @objc func cityDropDownClickAction() {
        self.cityTextField.becomeFirstResponder()
    }
    @objc func typeDropDownClickAction() {
        self.tournamentTypeTextField.becomeFirstResponder()
    }
    @objc func categoryDropDownClickAction() {
        self.categoryTextField.becomeFirstResponder()
    }
    @objc func sportDropDownClickAction() {
        self.eventSportTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rangeSlider.minimumValue = 0
        rangeSlider.maximumValue = 10000
    }
    
    func textFieldPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        cityTextField.delegate = self
        eventSportTextField.delegate = self
        categoryTextField.delegate = self
        tournamentTypeTextField.delegate = self
        
        cityTextField.inputView = pickerView
        eventSportTextField.inputView = pickerView
        categoryTextField.inputView = pickerView
        tournamentTypeTextField.inputView = pickerView
        
        self.pickerView = pickerView
    }
    
    private func getTournamentMasterDetails() {
        service.post(tournamentMasterUrl,parameters: nil,
                     onView: self.view) { (response: TournamentMasterResponse) in
            self.masterDetails = response.result
            self.cityArrayValues = self.masterDetails?.city?.map({$0.cityName ?? ""})
            self.typeArrayValues = self.masterDetails?.tournamentType?.map({$0.name ?? ""})
            self.categoryArrayValues = self.masterDetails?.sportsCategory?.map({$0.categoryName ?? ""})
            self.sportArrayValues = self.masterDetails?.sports?.map({$0.sportsName ?? ""})
        }
    }

    func buttonCornerRadius() {
        
        self.below5Button.layer.cornerRadius = 5.0
        self.below5Button.clipsToBounds = true
        
        self.below10Button.layer.cornerRadius = 5.0
        self.below10Button.clipsToBounds = true

        self.below15Button.layer.cornerRadius = 5.0
        self.below15Button.clipsToBounds = true

        self.below20Button.layer.cornerRadius = 5.0
        self.below20Button.clipsToBounds = true

        self.below30Button.layer.cornerRadius = 5.0
        self.below30Button.clipsToBounds = true
    }
    
    
    private func applyFilterListCall() {
        
        let selectedCityId = self.masterDetails?.city?.first(where: {
            return $0.cityName == self.cityTextField.text
        })?.id
        
        let selectedTournamentTypeId = self.masterDetails?.tournamentType?.first(where: {
            return $0.name == self.tournamentTypeTextField.text
        })?.id
        
        let selectedCategoryId = self.masterDetails?.sportsCategory?.first(where: {
            return $0.categoryName == self.categoryTextField.text
        })?.id
        let selectedSportId = self.masterDetails?.sports?.first(where: {
            return $0.sportsName == self.eventSportTextField.text
        })?.id
        
        let parameters:[String:Any] = ["latitude": "\(currentCoordinates?.latitude ?? 0)",
                          "longitude": "\(currentCoordinates?.longitude ?? 0)",
                          "radius" :clickedButtonTitle ?? "",
                          "price_range_start":self.priceMinValueLabel.text ?? "",
                          "price_range_end":self.priceMaxValueLabel.text ?? "",
                          "sport": selectedSportId ?? "",
                          "category":selectedCategoryId ?? "",
                          "type":selectedTournamentTypeId ?? "",
                          "city":selectedCityId ?? ""]
        
        self.delegate?.FilterdValues(parameters: parameters)
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func below5ButtonAction(_ sender: Any) {
        self.below5Button.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        clickedButtonTitle = self.below5Button.titleLabel?.text
        clickedButtonTitle = clickedButtonTitle?.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    @IBAction func below10ButtonAction(_ sender: Any) {
        self.below10Button.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        clickedButtonTitle = self.below10Button.titleLabel?.text
        clickedButtonTitle = clickedButtonTitle?.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    @IBAction func below15ButtonAction(_ sender: Any) {
        self.below15Button.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        clickedButtonTitle = self.below15Button.titleLabel?.text
        clickedButtonTitle = clickedButtonTitle?.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)

    }
    
    @IBAction func below20ButtonAction(_ sender: Any) {
        self.below20Button.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        clickedButtonTitle = self.below20Button.titleLabel?.text
        clickedButtonTitle = clickedButtonTitle?.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)


    }
    
    @IBAction func below30ButtonAction(_ sender: Any) {
        self.below30Button.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        clickedButtonTitle = self.below30Button.titleLabel?.text
        clickedButtonTitle = clickedButtonTitle?.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)

    }
}
extension TournamentFilterViewController : UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (self.cityTextField != nil && self.cityTextField == textField) {
            let cityValue = self.cityTextField?.text?.isEmpty == false ? self.cityTextField?.text : self.cityArrayValues?[0]
            cityTextField.text = cityValue
        } else if(self.tournamentTypeTextField != nil && self.tournamentTypeTextField == textField) {
            let tournamentTypeTextValue = self.tournamentTypeTextField?.text?.isEmpty == false ? self.tournamentTypeTextField?.text : self.typeArrayValues?[0]
            tournamentTypeTextField.text = tournamentTypeTextValue
        }else if(self.categoryTextField != nil && self.categoryTextField == textField) {
            let categoryTextValue = self.categoryTextField?.text?.isEmpty == false ? self.categoryTextField?.text : self.categoryArrayValues?[0]
            categoryTextField.text = categoryTextValue
        } else if (self.eventSportTextField != nil && self.eventSportTextField == textField) {
            let sportTextValue = self.eventSportTextField?.text?.isEmpty == false ? self.eventSportTextField?.text : self.sportArrayValues?[0]
            eventSportTextField.text = sportTextValue
        }
        self.pickerView?.reloadAllComponents()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if cityTextField.isFirstResponder{
            return cityArrayValues?.count ?? 0
        }else if tournamentTypeTextField.isFirstResponder{
            return typeArrayValues?.count ?? 0
        }else if categoryTextField.isFirstResponder{
            return categoryArrayValues?.count ?? 0
        }else if eventSportTextField.isFirstResponder{
            return sportArrayValues?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if cityTextField.isFirstResponder{
            let itemselected = cityArrayValues?[row]
            cityTextField.text = itemselected
         }else if tournamentTypeTextField.isFirstResponder{
            let itemselected = typeArrayValues?[row]
            tournamentTypeTextField.text = itemselected
         }else if categoryTextField.isFirstResponder{
            let itemselected = categoryArrayValues?[row]
            categoryTextField.text = itemselected
         }else if eventSportTextField.isFirstResponder{
            let itemselected = sportArrayValues?[row]
            eventSportTextField.text = itemselected
         }
     }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if cityTextField.isFirstResponder{
                return cityArrayValues?[row]
            }else if tournamentTypeTextField.isFirstResponder{
                return typeArrayValues?[row]
            }else if categoryTextField.isFirstResponder{
                return categoryArrayValues?[row]
            }else if eventSportTextField.isFirstResponder{
                return sportArrayValues?[row]
            }
            return nil
        }
}
extension TournamentFilterViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentCoordinates == nil {
            currentCoordinates = locations.last?.coordinate
        }
        currentCoordinates = locations.last?.coordinate
    }
    
}

