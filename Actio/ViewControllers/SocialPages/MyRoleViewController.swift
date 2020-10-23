//
//  MyProfileViewController.swift
//  Actio
//
//  Created by apple on 21/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class MyRoleViewController: UIViewController {

    @IBOutlet weak var editProfileTableView: UITableView!
    fileprivate var formData: [FormCellType]?
    var myRoleData: ProfileMaster?
    var getProfileData: GetProfile?
    private let service = DependencyProvider.shared.networkService
    var sportArrayValues: [String]?
    var stateArrayValues: [String]?
    var cityArrayValues: [String]?

        override func viewDidLoad() {
            super.viewDidLoad()
            myRoleProfile()
            self.formData = self.prepareFormData()
            editProfileTableView.delegate = self
            editProfileTableView.dataSource = self
            
            editProfileTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
            editProfileTableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
            editProfileTableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
            editProfileTableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
            self.editProfileTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            editProfileTableView.contentInset = .zero
            editProfileTableView.reloadData()

        }
    
        private func getProfile() {
            service.post(getProfileUrl, parameters: nil, onView: view) { (response: GetProfileDataResponse) in
                self.getProfileData = response.profile
                self.editProfileTableView.reloadData()
            }
        }

        private func myRoleProfile() {
            service.post(masterProfileUrl, parameters: nil, onView: view) { (response: ProfileMasterResponse) in
                self.myRoleData = response.master
                self.sportArrayValues = self.myRoleData?.sports?.map({$0.sports ?? ""})
                self.stateArrayValues = self.myRoleData?.state?.map({$0.state ?? ""})
                self.cityArrayValues = self.myRoleData?.city
                self.formData = self.prepareFormData()
                
            }
        }
        
        private func prepareFormData() -> [FormCellType] {
            
            let states = self.myRoleData?.state?.map({ (state) -> String in
                return state.state ?? ""
            }) ?? []
            let institution = self.myRoleData?.institute?.map({ (institute) -> String in
                return institute.instituteName ?? ""
            }) ?? []
            let country = self.myRoleData?.country?.map({ (country) -> String in
                return country.country ?? ""
            }) ?? []
            

            let studentString = NSMutableAttributedString(string: "Are you student at school/university?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
            let coachingString = NSMutableAttributedString(string: "Do you conduct coaching?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
            let sponserString = NSMutableAttributedString(string: "Do you wish to sponser any tournament?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
            let organizeString = NSMutableAttributedString(string: "Do you wish to organize Events?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
           
            let formData: [FormCellType] = [
                .toggle(ToggleViewModel(key: "student", contextText: studentString, defaultValue: false)),
                .textPicker(TextPickerModel(key: "institute", textValue:"", allValues: institution, contextText: "I am studying at",placeHolder: "Select Institution")),
                .academic,
                .textPicker(TextPickerModel(key: "class", textValue:"", allValues: [], contextText: "Class",placeHolder: "Select Class")),
                .textPicker(TextPickerModel(key: "stream", textValue:"", allValues: [], contextText: "Stream",placeHolder: "Select Stream")),
                .textPicker(TextPickerModel(key: "divison", textValue:"", allValues: [], contextText: "Divison",placeHolder: "Select Divison")),
                .textPicker(TextPickerModel(key: "country", textValue:"", allValues: country, contextText: "Country",placeHolder: "Select Country")),
                .textPicker(TextPickerModel(key: "state", textValue:"", allValues: states, contextText: "State",placeHolder: "Select State")),
                .textPicker(TextPickerModel(key: "city", textValue:"", allValues: [], contextText: "City",placeHolder: "Select City")),
                .textEdit(TextEditModel(key: "postalcode", textValue: "", contextText: "Postal Code", placeHolder: "Postal Code", isSecure: false)),
                .sportsPlay,
                .button("+ Add Another sport you play"),
                .toggle(ToggleViewModel(key: "coach", contextText: coachingString, defaultValue: false)),
                .sportsCoach,
                .toggle(ToggleViewModel(key: "sponser", contextText: sponserString, defaultValue: false)),
                .textEdit(TextEditModel(key: "sponsership", textValue: "", contextText: "About Sponsorship", placeHolder: "Enter about sponsorship", isSecure: false)),
                .toggle(ToggleViewModel(key: "organize", contextText: organizeString, defaultValue: false)),
                .textEdit(TextEditModel(key: "organizeEvents", textValue: "", contextText: "About Organizing Events", placeHolder: "Enter about organizing events", isSecure: false)),
              ]
             return formData
        }

    }

    extension MyRoleViewController :  UITableViewDataSource, UITableViewDelegate {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.formData?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: UITableViewCell? = nil
            guard let cellData = self.formData?[indexPath.row] else { return UITableViewCell() }
            
            switch cellData {
            
            case .toggle(let model):
                guard let toggleCell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseId, for: indexPath) as? SwitchTableViewCell else {
                    return UITableViewCell()
                }
                
                toggleCell.configure(model, delegate: self)
                cell = toggleCell
                
                
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
                
            case .button( _):
                guard let addCell = tableView.dequeueReusableCell(withIdentifier: AddAnotherSportTableViewCell.reuseId, for: indexPath) as? AddAnotherSportTableViewCell else {
                    return UITableViewCell()
                }
                cell = addCell
            case .sportsPlay:
                guard let playCell = tableView.dequeueReusableCell(withIdentifier: SportsPlayTableViewCell.reuseId, for: indexPath) as? SportsPlayTableViewCell else {
                    return UITableViewCell()
                }
                playCell.sportArrayValues = self.sportArrayValues
                cell = playCell
            case .sportsCoach:
                guard let coachCell = tableView.dequeueReusableCell(withIdentifier: SportsCoachTableViewCell.reuseId, for: indexPath) as? SportsCoachTableViewCell else {
                    return UITableViewCell()
                }
                coachCell.sportArrayValues = self.sportArrayValues
                coachCell.stateArrayValues = self.stateArrayValues
                coachCell.cityArrayValues = self.cityArrayValues
                cell = coachCell
            case .academic:
                guard let academicCell = tableView.dequeueReusableCell(withIdentifier: AcademicYearTableViewCell.reuseId, for: indexPath) as? AcademicYearTableViewCell else {
                    return UITableViewCell()
                }
                cell = academicCell
            }
            
            cell?.selectionStyle = .none
            
            return cell ?? UITableViewCell()
        }
        
    }
    extension MyRoleViewController : FootnoteButtonDelegate, CellDataFetchProtocol, TextPickerDelegate, SwitchCellDelegate, SegmentCellDelegate {
        func footnoteButtonCallback(_ title: String) {
            print("something")
        }
        
        func valueChanged(keyValuePair: (key: String, value: String)) {
            print("something")
            
        }
        
        func didPickText(_ key: String, index: Int) {
            print("something")
            
        }
        
        func toggleValueChanged(_ key: String, value: Bool) {
            print("something")
            
        }
        
        func segmentTapped(_ index: Int) {
            print("something")
            
        }
        
        
    }

    private enum FormCellType {
        case academic
        case sportsPlay
        case sportsCoach
        case textEdit(TextEditModel)
        case textPicker(TextPickerModel)
        case button(String)
        case toggle(ToggleViewModel)
    }



