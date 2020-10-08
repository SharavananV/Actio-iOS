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

class TournamentFilterViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var priceMaxValueLabel: UILabel!
    @IBOutlet weak var priceMinValueLabel: UILabel!
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var eventSportTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var tournamentTypeTextField: UITextField!
    
    @IBOutlet weak var below5Button: UIButton!
    @IBOutlet weak var below10Button: UIButton!
    @IBOutlet weak var below15Button: UIButton!
    @IBOutlet weak var below20Button: UIButton!
    @IBOutlet weak var below30Button: UIButton!

    @IBOutlet weak var rangeSlider: RangeSlider!
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
    var itemSelected = ""
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
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
 
        
        cityTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        eventSportTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        categoryTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        tournamentTypeTextField.setBorderColor(width: 1.0, color: AppColor.TextFieldBorderColor())
        self.applyFilterButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        self.applyFilterButton.layer.cornerRadius = 5.0
        self.applyFilterButton.clipsToBounds = true
        buttonCornerRadius()
        getTournamentMasterDetails()
        textFieldPickerView()
        
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
    
    
    @IBAction func applyFilterButtonAction(_ sender: Any) {
        applyFilterListCall()

    }
    
    private func applyFilterListCall() {
        
        let selectedCityId = self.masterDetails?.city?.first(where: {
            return $0.cityName == self.cityTextField.text
        })?.id
        
        service.post(tournamentListUrl,parameters: ["latitude": "\(currentCoordinates?.latitude ?? 0)", "longitude": "\(currentCoordinates?.longitude ?? 0)","radius" :clickedButtonTitle ?? "","price_range_start":self.priceMinValueLabel.text ?? "","price_range_end":self.priceMaxValueLabel.text ?? "","sport":self.eventSportTextField.text ?? "","category":self.categoryTextField.text ?? "","type":self.tournamentTypeTextField.text ?? "","city":selectedCityId ?? ""],
                     onView: self.view) { (response: TournamentListResponse) in
            self.tournamentListModel = response.list
            self.view.makeToast(response.status)
        }
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

