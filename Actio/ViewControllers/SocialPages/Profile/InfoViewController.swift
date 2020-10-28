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
    var masterData: ProfileMaster?
    var profileRoleModel = ProfileRoleModel()
    private lazy var imagePicker = ActioImagePicker(presentationController: self, delegate: self)
    private var lastPickedCell: ImagePickerTableViewCell?
    private let service = DependencyProvider.shared.networkService

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
        self.setObservers()
        myRoleProfile()
        self.infoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.formData = prepareFormData()
        infoTableView.reloadData()
    }
    
    private func myRoleProfile() {
        
        service.post(masterProfileUrl, parameters: nil, onView: view) { (response: ProfileMasterResponse) in
            self.masterData = response.master
            self.formData = self.prepareFormData()
        }
    }

    
    private func setObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            infoTableView.contentInset = .zero
        } else {
            infoTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height-view.safeAreaInsets.bottom, right: 0)
        }
        
        infoTableView.scrollIndicatorInsets = infoTableView.contentInset
    }

     
    private func prepareFormData() -> [FormCellType] {
        
        let allZipCodes = self.masterData?.country?.map({ (country) -> String in
            return country.code ?? ""
        }) ?? []
        let allIdTypes = self.masterData?.idTypes?.map({ (idTypes) -> String in
            return idTypes.proof ?? ""
        }) ?? []
        
        let formData: [FormCellType] = [
            .textEdit(TextEditModel(key: "fullName", textValue: userDetails?.fullName, contextText: "Full Name", placeHolder: "Full Name", isSecure: false,enabled: false)),
            .textPicker(TextPickerModel(key: "isdCode", textValue:userDetails?.isdCode, allValues: allZipCodes, contextText: "Country Code",placeHolder: "Country Code")),
            .textEdit(TextEditModel(key: "mobileNumber", textValue: userDetails?.mobileNumber, contextText: "Mobile Number", placeHolder: "Mobile Number", keyboardType: .phonePad, isSecure: false)),
            .textEdit(TextEditModel(key: "gender", textValue: userDetails?.gender, contextText: "Gender", placeHolder: "Select Gender", isSecure: false,enabled: false)),
            .textEdit(TextEditModel(key: "emailID", textValue: userDetails?.emailID, contextText: "Email ID", placeHolder: "Email ID", keyboardType: .emailAddress, isSecure: false)),
            .textEdit(TextEditModel(key: "dob", textValue: userDetails?.dob, contextText: "Date of Birth (dd-mm-yyyy)", placeHolder: "Date of Birth (dd-mm-yyyy)", keyboardType: .emailAddress, isSecure: false,enabled: false)),
            .textEdit(TextEditModel(key: "userName", textValue: userDetails?.username, contextText: "Username", placeHolder: "Username allows a-z,0-9,_,.",enabled: true)),
            .textPicker(TextPickerModel(key: "idType", textValue:userDetails?.idType, allValues: allIdTypes, contextText: "ID Type",placeHolder: "Select ID Type")),
            .textEdit(TextEditModel(key: "idNumber", contextText: "ID Number", placeHolder: "ID Type Number", keyboardType: .numberPad, isSecure: false)),
            .text("Upload ID", .natural),
            .imagePicker(ImagePickerModel(key: "frontImage", titleText: "Click here to upload Front Side Image", contextText: "Front Image")),
            .imagePicker(ImagePickerModel(key: "backImage", titleText: "Click here to upload Back Side Image", contextText: "Back Image")),
            .button("UPDATE")
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

    
extension InfoViewController : FootnoteButtonDelegate, CellDataFetchProtocol, TextPickerDelegate, SwitchCellDelegate, SegmentCellDelegate,ImagePickerCellDelegate,ActioPickerDelegate {
    func didSelect(url: URL?, type: String) {
        self.lastPickedCell?.model?.imageUrl = url
        self.lastPickedCell?.refreshTitleText()
        
        guard let key = self.lastPickedCell?.model?.key, let codingKey = RegisterUser.CodingKeys(rawValue: key), let url = url else { return }
        
        do {
            let mediaData = try Data(contentsOf: url)
            
            switch codingKey {
            case .frontImage:
                self.profileRoleModel.frontImage = mediaData
            case .backImage:
                self.profileRoleModel.backImage = mediaData
            default:
                break
            }
        }
        catch {
            print("Error when converting media to data")
        }
    }
    func pickImage(_ key: String, cell: ImagePickerTableViewCell) {
        self.lastPickedCell = cell
        imagePicker.present(from: self.view)
    }
    
   
    func didPickText(_ key: String, index: Int) {
        switch key {
        case "isdCode":
            if self.masterData?.country?.isEmpty == false, let countryId = self.masterData?.country?[index].code {
                self.profileRoleModel.countryID = String(countryId)
            }
        case "idType":
            if self.masterData?.idTypes?.isEmpty == false, let countryId = self.masterData?.idTypes?[index].id {
            }
        default:
            break
        }

    }

    
    func footnoteButtonCallback(_ title: String) {
        print("footnoteButtonCallback")
    }
    
    func valueChanged(keyValuePair: (key: String, value: String)) {
        print("valueChanged")
        
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

