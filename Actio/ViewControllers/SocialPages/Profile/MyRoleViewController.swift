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
    var masterData : MasterData?
    private let service = DependencyProvider.shared.networkService
    var sportArrayValues: [String]?
    var stateArrayValues: [String]?
    var cityArrayValues: [String]?
    var selectedArrayValues: String?
    var profileRoleModel = ProfileRoleModel()
    var stateName: [String]?
    
    var instituteName : String?
    var fromYearString: Int?
    var toYearString: Int?
    var insClass : String?
    var stream :String?
    var division :String?
    var playSportsName : [String]?
    var playerSince : [Int]?
    var weeklyHour : [Int]?
    var coachSportsName : [String]?
    var coachState : [String]?
    var coachCity : [String]?
    var coachLocality : [String]?
    var coachabout : [String]?

        override func viewDidLoad() {
            super.viewDidLoad()
            getProfileCall()
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
    
        private func getProfileCall() {
            service.post(getProfileUrl, parameters: nil, onView: view) { (response: GetProfileDataResponse) in
                self.getProfileData = response.profile
                print(response.profile,"==========")
                self.myRoleProfileCall()
                self.profileRoleModel = ProfileRoleModel(data: response.profile)
                self.formData = self.prepareFormData()
                self.editProfileTableView.reloadData()
            }
        }

        private func myRoleProfileCall() {
            let parameters = [ "instituteID":self.getProfileData?.institute?.instituteID ?? "" , "classID": self.getProfileData?.institute?.classID ?? "" , "streamID": self.getProfileData?.institute?.streamID ?? "" ,"countryID":self.getProfileData?.institute?.countryID ?? "" ,"stateID":"","stateCity":true] as [String : Any]
            service.post(masterProfileUrl, parameters: parameters, onView: view) { (response: ProfileMasterResponse) in
                self.myRoleData = response.master
                self.sportArrayValues = self.myRoleData?.sports?.map({$0.sports ?? ""})
                self.stateArrayValues = self.myRoleData?.state?.map({$0.state ?? ""})
                self.cityArrayValues = self.myRoleData?.stateCity?.map({$0.stateName ?? ""})
                self.formData = self.prepareFormData()
            }
        }
        
    private func prepareFormData(shouldAddEmptyPlayCell: Bool = false) -> [FormCellType] {
        
        let states = self.myRoleData?.stateCity?.map({ (state) -> String in
            return state.stateName ?? ""
        }) ?? []
        let selectedState = self.myRoleData?.stateCity?.first(where: {
            String($0.stateID ?? 0) == self.profileRoleModel.stateID
        })
        
        let cityValues = self.myRoleData?.stateCity?.map({$0.city})
        
        guard let cityObj = cityValues?.first else {
            return formData ?? []
        }
        
        let CityName = cityObj?.map({ (sCity) -> String in
            return sCity.cityName ?? ""
        }) ?? []
        
        let selectedstateCity = cityObj?.first(where: {
            String($0.cityID ?? 0) == self.profileRoleModel.cityID
        })
        
        let institution = self.myRoleData?.institute?.map({ (institute) -> String in
            return institute.instituteName ?? ""
        }) ?? []
        let selectedinstitution = self.myRoleData?.institute?.first(where: {
            String($0.id ?? 0) == self.profileRoleModel.instituteID
        })
        
        let roleclass = self.myRoleData?.instituteClass?.map({ (instituteClass) -> String in
            return instituteClass.instituteClass ?? ""
        }) ?? []
        let selectedroleclass = self.myRoleData?.instituteClass?.first(where: {
            String($0.id ?? 0) == self.profileRoleModel.instituteID
        })
        
        let country = self.myRoleData?.country?.map({ (country) -> String in
            return country.country ?? ""
        }) ?? []
        
        let selectedCountry = self.myRoleData?.country?.first(where: {
            String($0.id ?? 0) == self.profileRoleModel.countryID
        })
        
        let stream = self.myRoleData?.instituteStream?.map({ (instituteStream) -> String in
            return instituteStream.stream ?? ""
        }) ?? []
        
        let selectedstream = self.myRoleData?.instituteStream?.first(where: {
            String($0.id ?? 0) == self.profileRoleModel.streamID
        })
        let divison = self.myRoleData?.institutedivision?.map({ (institutedivision) -> String in
            return institutedivision.division ?? ""
        }) ?? []
        
        let selecteddivison = self.myRoleData?.institutedivision?.first(where: {
            String($0.id ?? 0) == self.profileRoleModel.divisonID
        })
        
        var sportsPlayAdd: [FormCellType] = self.profileRoleModel.sportsPlay?.map({ (play) -> FormCellType in
            .sportsPlay(play)
        }) ?? [.sportsPlay(nil)]
        
        var sportsCoachAdd: [FormCellType] = self.profileRoleModel.coaching?.map({ (coach) -> FormCellType in
            .sportsCoach(coach)
        }) ?? [.sportsCoach(nil)]
        
        if shouldAddEmptyPlayCell {
            sportsPlayAdd.append(.sportsPlay(nil))
        }
        
        let studentString = NSMutableAttributedString(string: "Are you student at school/university?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        let coachingString = NSMutableAttributedString(string: "Do you conduct coaching?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        let sponserString = NSMutableAttributedString(string: "Do you wish to sponser any tournament?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        let organizeString = NSMutableAttributedString(string: "Do you wish to organize Events?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        
        var formData: [FormCellType] = [
            .toggle(ToggleViewModel(key: "student", contextText: studentString, defaultValue: (profileRoleModel.isStudent == true))),
            .textPicker(TextPickerModel(key: "institute", textValue:selectedinstitution?.instituteName, allValues: institution, contextText: "I am studying at",placeHolder: "Select Institution")),
            .academic(profileRoleModel.institute),
            .textPicker(TextPickerModel(key: "class", textValue:selectedroleclass?.instituteClass, allValues: roleclass, contextText: "Class",placeHolder: "Select Class")),
            .textPicker(TextPickerModel(key: "stream", textValue:selectedstream?.stream, allValues: stream, contextText: "Stream",placeHolder: "Select Stream")),
            .textPicker(TextPickerModel(key: "divison", textValue:selecteddivison?.division, allValues: divison, contextText: "Divison",placeHolder: "Select Divison")),
            .textPicker(TextPickerModel(key: "country", textValue:selectedCountry?.country, allValues: country, contextText: "Country",placeHolder: "Select Country")),
            .textPicker(TextPickerModel(key: "state", textValue:selectedState?.stateName, allValues: states, contextText: "State",placeHolder: "Select State")),
            .textPicker(TextPickerModel(key: "city", textValue:selectedstateCity?.cityName, allValues: CityName, contextText: "City",placeHolder: "Select City")),
            .textEdit(TextEditModel(key: "postalcode", textValue: profileRoleModel.postalCode, contextText: "Postal Code", placeHolder: "Postal Code", isSecure: false)),
            .addCell("+ Add Another sport you play"),
            .toggle(ToggleViewModel(key: "coach", contextText: coachingString, defaultValue: (profileRoleModel.isCoach == true))),
            .toggle(ToggleViewModel(key: "sponser", contextText: sponserString, defaultValue: (profileRoleModel.isSponser == true))),
            .toggle(ToggleViewModel(key: "organize", contextText: organizeString, defaultValue: (profileRoleModel.isOrganizer == true))),
            .button("Submit")
        ]
        
        formData.insert(contentsOf: sportsPlayAdd, at: 10)
        if profileRoleModel.isCoach == true {
            let coachData: [FormCellType] = [
                .addCell("+ Add Another sport you Coach")
            ]
            formData.insert(contentsOf: sportsCoachAdd, at: 13)
            formData.insert(contentsOf: coachData, at: 14)
        }
        if profileRoleModel.isSponser == true {
            let sponserData: [FormCellType] = [
                .textEdit(TextEditModel(key: "sponsership", textValue: "", contextText: "About Sponsorship", placeHolder: "Enter about sponsorship", isSecure: false))
            ]
            formData.insert(contentsOf: sponserData, at: 16)
        }
        if profileRoleModel.isOrganizer == true {
            let organizerData: [FormCellType] = [
                .textEdit(TextEditModel(key: "organizeEvents", textValue: "", contextText: "About Organizing Events", placeHolder: "Enter about organizing events", isSecure: false))
            ]
            formData.insert(contentsOf: organizerData, at: 18)
        }
        self.formData = formData
        UIView.setAnimationsEnabled(false)
        self.editProfileTableView.beginUpdates()
        self.editProfileTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
        self.editProfileTableView.endUpdates()
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
            
        case .button(let title):
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: FootnoteButtonTableViewCell.reuseId, for: indexPath) as? FootnoteButtonTableViewCell else {
                return UITableViewCell()
            }
            
            buttonCell.configure(title: title, delegate: self)
            cell = buttonCell
            
            
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
            
        case .sportsPlay(let data):
            guard let playCell = tableView.dequeueReusableCell(withIdentifier: SportsPlayTableViewCell.reuseId, for: indexPath) as? SportsPlayTableViewCell else {
                return UITableViewCell()
            }
            playCell.sportArrayValues = self.sportArrayValues
            playCell.selectSportTextField.text = data?.sportsName
            playCell.playerSinceTextField.text = String(data?.playingSince ?? 0)
            playCell.practiceHoursTextField.text = String(data?.weeklyHours ?? 0)
            cell = playCell
        case .sportsCoach(let coach):
            guard let coachCell = tableView.dequeueReusableCell(withIdentifier: SportsCoachTableViewCell.reuseId, for: indexPath) as? SportsCoachTableViewCell else {
                return UITableViewCell()
            }
            coachCell.sportArrayValues = self.sportArrayValues
            coachCell.stateArrayValues = self.stateArrayValues
            coachCell.cityArrayValues = self.cityArrayValues
            coachCell.coachSelectSportTextField.text = coach?.sportsName
            coachCell.cityTextField.text = coach?.cityName
            coachCell.stateTextField.text = coach?.stateName
            coachCell.localityTextField.text = coach?.locality
            coachCell.aboutCoachingTextField.text = coach?.remarks

            cell = coachCell
        case .academic(let data):
            guard let academicCell = tableView.dequeueReusableCell(withIdentifier: AcademicYearTableViewCell.reuseId, for: indexPath) as? AcademicYearTableViewCell else {
                return UITableViewCell()
            }
            cell = academicCell
            academicCell.toYearTextField.text = String(data?.academicToYear ?? 0)
            academicCell.fromYearTextField.text = String(data?.academicFromYear ?? 0)
        case .addCell(let title):
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: AddAnotherSportTableViewCell.reuseId, for: indexPath) as? AddAnotherSportTableViewCell else {
                return UITableViewCell()
            }
            cell = addCell
        }
        
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? AddAnotherSportTableViewCell) != nil {
            self.formData = prepareFormData(shouldAddEmptyPlayCell: true)
            tableView.reloadData()
        }
    }
}
extension MyRoleViewController : FootnoteButtonDelegate, CellDataFetchProtocol, TextPickerDelegate, SwitchCellDelegate {
    func footnoteButtonCallback(_ title: String) {
        updateProfileMyRole()
    }
    
    private func updateProfileMyRole() {
        service.post(ProfileUrl, parameters: profileRoleModel.parameters(), onView: view) { (response) in
            if let msg = response["msg"] as? String {
                print(self.profileRoleModel.parameters(),"===============")
                self.view.makeToast(msg)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
        
    func valueChanged(keyValuePair: (key: String, value: String)) {
        print("something")
        
    }
        
    func didPickText(_ key: String, index: Int) {
        switch key {
        case "country":
            if self.myRoleData?.country?.isEmpty == false, let countryId = self.myRoleData?.country?[index].id {
                self.profileRoleModel.countryID = String(countryId)
            }
        case "state":
            if self.myRoleData?.state?.isEmpty == false, let stateId = self.myRoleData?.state?[index].id {
                self.profileRoleModel.stateID = String(stateId)
            }
        case "institute":
            if self.myRoleData?.institute?.isEmpty == false, let instituteId = self.myRoleData?.institute?[index].id {
                self.profileRoleModel.instituteID = String(instituteId)
            }
        case "class":
            if self.myRoleData?.instituteClass?.isEmpty == false, let instituteclassId = self.myRoleData?.instituteClass?[index].id {
                self.profileRoleModel.classID = String(instituteclassId)
            }
        default:
            break
        }

    }
    
    func toggleValueChanged(_ key: String, value: Bool) {
        if key == "coach" {
            profileRoleModel.isCoach = value
            prepareFormData()
        }
        else if key == "sponser" {
            profileRoleModel.isSponser = value
            prepareFormData()

        }
        else if key == "organize" {
            profileRoleModel.isOrganizer = value
            prepareFormData()
        }
    }
   
}

private enum FormCellType {
    case academic(Institute?)
    case sportsPlay(Play?)
    case sportsCoach(Coaching?)
    case addCell(String)
    case textEdit(TextEditModel)
    case textPicker(TextPickerModel)
    case toggle(ToggleViewModel)
    case button(String)

}



