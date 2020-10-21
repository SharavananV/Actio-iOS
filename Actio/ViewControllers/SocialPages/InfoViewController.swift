//
//  InfoViewController.swift
//  Actio
//
//  Created by apple on 21/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit


class InfoViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    fileprivate var formData: [FormCellType]?
    var userDetails: Friend?
    var masterData: MasterData?
    private var lastPickedCell: ImagePickerTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        infoTableView.delegate = self
        infoTableView.dataSource = self
                
        infoTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
        infoTableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
        infoTableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
        infoTableView.register(AcademicYearTableViewCell.self, forCellReuseIdentifier: AcademicYearTableViewCell.reuseId)
        infoTableView.register(SportsPlayTableViewCell.self, forCellReuseIdentifier: SportsPlayTableViewCell.reuseId)
        infoTableView.register(SportsCoachTableViewCell.self, forCellReuseIdentifier: SportsCoachTableViewCell.reuseId)
        infoTableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
        infoTableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.reuseId)
        infoTableView.register(JustTextTableViewCell.self, forCellReuseIdentifier: JustTextTableViewCell.reuseId)
        infoTableView.register(ImagePickerTableViewCell.self, forCellReuseIdentifier: ImagePickerTableViewCell.reuseId)

        self.infoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.formData = prepareFormData()
        infoTableView.reloadData()
    }
     
    private func prepareFormData() -> [FormCellType] {
        var allCountries = [String]()
        var allGender = [String]()
        var allIDCards = [String]()
        var genderString = ""
        var startDate : Date = Date()
        
        if let masterData = masterData {
            allCountries = masterData.country?.compactMap({
                return "(\($0.alias ?? "")) \($0.code ?? "")"
            }) ?? []
            
            allIDCards = masterData.proof?.map({
                return $0.proof ?? ""
            }) ?? []
            
            allGender = masterData.gender?.map({
                return ($0.gender ?? "")
            }) ?? []
            
        }

        
        let formData: [FormCellType] = [
            .textEdit(TextEditModel(key: "fullName", textValue: userDetails?.fullName, contextText: "Full Name", placeHolder: "Full Name", isSecure: false)),
            .textPicker(TextPickerModel(key: "isdCode", textValue: userDetails?.isdCode, allValues: allCountries, contextText: "Country Code")),
            .textEdit(TextEditModel(key: "mobileNumber", textValue: userDetails?.mobileNumber, contextText: "Mobile Number", placeHolder: "Mobile Number", keyboardType: .phonePad, isSecure: false)),
            .textPicker(TextPickerModel(key: "gender", textValue: genderString, allValues: allGender, contextText: "Gender", placeHolder: "Select Gender")),
            .textEdit(TextEditModel(key: "emailID", textValue: userDetails?.emailID, contextText: "Email ID", placeHolder: "Email ID", keyboardType: .emailAddress, isSecure: false)),
            .date(DatePickerModel(key: "dob", minDate: nil, maxDate: Date(), dateValue: startDate, contextText: "Date of Birth (dd-mm-yyyy)")),
            .textEdit(TextEditModel(key: "userName", textValue: userDetails?.username, contextText: "Username", placeHolder: "Username allows a-z,0-9,_,.")),
            .textPicker(TextPickerModel(key: "idType", allValues: allIDCards, contextText: "ID Type", placeHolder: "Select ID Type")),
            .textEdit(TextEditModel(key: "idNumber", contextText: "ID Number", placeHolder: "ID Type Number", keyboardType: .numberPad, isSecure: false)),
            .text("Upload ID", .natural),
            .imagePicker(ImagePickerModel(key: "frontImage", titleText: "Click here to upload Front Side Image", contextText: "Front Image")),
            .imagePicker(ImagePickerModel(key: "backImage", titleText: "Click here to upload Back Side Image", contextText: "Back Image")),
        ]
        return formData

    }

}

extension InfoViewController : UITableViewDataSource,UITableViewDelegate {
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
        case .date(let model):
            guard let dateCell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.reuseId, for: indexPath) as? DatePickerTableViewCell else {
                return UITableViewCell()
            }
            
            dateCell.configure(model)
            dateCell.delegate = self
            cell = dateCell
            
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
            
        case .imagePicker(let model):
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: ImagePickerTableViewCell.reuseId, for: indexPath) as? ImagePickerTableViewCell else {
                return UITableViewCell()
            }
            
            buttonCell.configure(model, delegate: self)
            cell = buttonCell
            
        case .text(let text, let alignment):
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: JustTextTableViewCell.reuseId, for: indexPath) as? JustTextTableViewCell else {
                return UITableViewCell()
            }
            
            textCell.configure(text, nil, alignment: alignment)
            cell = textCell
        }
        
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }

    }
    
extension InfoViewController : FootnoteButtonDelegate, CellDataFetchProtocol, TextPickerDelegate, SwitchCellDelegate, SegmentCellDelegate,ImagePickerCellDelegate {
    func pickImage(_ key: String, cell: ImagePickerTableViewCell) {
        self.lastPickedCell = cell
    }
    
    func footnoteButtonCallback(_ title: String) {
        print("footnoteButtonCallback")
    }
    
    func valueChanged(keyValuePair: (key: String, value: String)) {
        print("valueChanged")
        
    }
    
    func didPickText(_ key: String, index: Int) {
    }
    
    private func updateCellFormData(key: String, value: String) {
        // Update form data
        let cellData = self.formData?.first(where: { (cellType) -> Bool in
            switch cellType {
            case .textEdit(let model):
                return model.key == key
            case .date(let model):
                return model.key == key
            case .textPicker(let model):
                return model.key == key
            default:
                return false
            }
        })
        
        switch cellData {
        case .textEdit(let model):
            model.textValue = value
        case .date(let model):
            model.dateValue = value.toDate
        case .textPicker(let model):
            return model.textValue = value
        default:
            break;
        }
    }

    
    func toggleValueChanged(_ key: String, value: Bool) {
        print("toggleValueChanged xcx")
        
    }
    
    func segmentTapped(_ index: Int) {
        print("segmentTapped")
        
    }
    
    
}


private enum FormCellType {
    case textEdit(TextEditModel)
    case textPicker(TextPickerModel)
    case button(String)
    case date(DatePickerModel)
    case imagePicker(ImagePickerModel)
    case text(String, NSTextAlignment)


}

