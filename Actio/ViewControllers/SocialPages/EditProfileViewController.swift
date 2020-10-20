//
//  EditProfileViewController.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editProfileImage: UIImageView!
    @IBOutlet weak var profileSegmentControl: UISegmentedControl!
    @IBOutlet weak var editProfileTableView: UITableView!
    fileprivate var formData: [FormCellType]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileTableView.delegate = self
        editProfileTableView.dataSource = self
        
        editProfileTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
        editProfileTableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
        editProfileTableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
        editProfileTableView.register(AcademicYearTableViewCell.self, forCellReuseIdentifier: AcademicYearTableViewCell.reuseId)
        editProfileTableView.register(SportsPlayTableViewCell.self, forCellReuseIdentifier: SportsPlayTableViewCell.reuseId)
        editProfileTableView.register(SportsCoachTableViewCell.self, forCellReuseIdentifier: SportsCoachTableViewCell.reuseId)
        editProfileTableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
        self.editProfileTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.formData = prepareFormData()
        editProfileTableView.reloadData()

    }
    
    private func prepareFormData() -> [FormCellType] {
        
        var allInstitution = [String]()
        var allClass = [String]()
        var allStream = [String]()
        var allDivision = [String]()
        var allCountry = [String]()
        var allState = [String]()
        var allCity = [String]()
        var allCoach = [String]()

        let studentString = NSMutableAttributedString(string: "Are you student at school/university?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        let coachingString = NSMutableAttributedString(string: "Do you conduct coaching?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        let sponserString = NSMutableAttributedString(string: "Do you wish to sponser any tournament?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        let organizeString = NSMutableAttributedString(string: "Do you wish to organize Events?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
       
        let formData: [FormCellType] = [
            .toggle(ToggleViewModel(key: "student", contextText: studentString, defaultValue: false)),
            .textPicker(TextPickerModel(key: "institution", textValue:"", allValues: allInstitution, contextText: "I am studying at",placeHolder: "Select Institution")),
            .textPicker(TextPickerModel(key: "class", textValue:"", allValues: allClass, contextText: "Class",placeHolder: "Select Class")),
            .textPicker(TextPickerModel(key: "stream", textValue:"", allValues: allStream, contextText: "Stream",placeHolder: "Select Stream")),
            .textPicker(TextPickerModel(key: "divison", textValue:"", allValues: allDivision, contextText: "Divison",placeHolder: "Select Divison")),
            .textPicker(TextPickerModel(key: "country", textValue:"", allValues: allCountry, contextText: "Country",placeHolder: "Select Country")),
            .textPicker(TextPickerModel(key: "state", textValue:"", allValues: allState, contextText: "State",placeHolder: "Select State")),
            .textPicker(TextPickerModel(key: "city", textValue:"", allValues: allCity, contextText: "City",placeHolder: "Select City")),
            .textEdit(TextEditModel(key: "postalcode", textValue: "", contextText: "Postal Code", placeHolder: "Postal Code", isSecure: false)),
            .button("+ Add Another sport you play"),
            .sportsCoach,
            .sportsPlay,
            .toggle(ToggleViewModel(key: "coach", contextText: coachingString, defaultValue: false)),
            .toggle(ToggleViewModel(key: "sponser", contextText: sponserString, defaultValue: false)),
            .toggle(ToggleViewModel(key: "organize", contextText: organizeString, defaultValue: false)),
        
            
          ]
         return formData
    }

}

extension EditProfileViewController :  UITableViewDataSource, UITableViewDelegate {
    
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
            
        case .button(let title):
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: FootnoteButtonTableViewCell.reuseId, for: indexPath) as? FootnoteButtonTableViewCell else {
                return UITableViewCell()
            }
            
            buttonCell.configure(title: title, delegate: self)
            cell = buttonCell
        case .sportsPlay:
            guard let playCell = tableView.dequeueReusableCell(withIdentifier: SportsPlayTableViewCell.reuseId, for: indexPath) as? SportsPlayTableViewCell else {
                return UITableViewCell()
            }
            cell = playCell
        case .sportsCoach:
            guard let coachCell = tableView.dequeueReusableCell(withIdentifier: SportsCoachTableViewCell.reuseId, for: indexPath) as? SportsCoachTableViewCell else {
                return UITableViewCell()
            }
            cell = coachCell
        }
        
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
    
    
    
}
extension EditProfileViewController : FootnoteButtonDelegate, CellDataFetchProtocol, TextPickerDelegate, SwitchCellDelegate, SegmentCellDelegate {
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
    case textEdit(TextEditModel)
    case textPicker(TextPickerModel)
    case button(String)
    case toggle(ToggleViewModel)
    case sportsPlay
    case sportsCoach
}



