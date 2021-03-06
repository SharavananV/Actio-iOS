//
//  SignupViewController.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Toast_Swift

class SignupViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var registerUserModel: RegisterUser = RegisterUser()
    fileprivate var formData: [FormCellType]?
    fileprivate var registerDatasource: RegisterDatasource = {
        return DependencyProvider.shared.registerDatasource
    }()
    
    private lazy var imagePicker = ActioImagePicker(presentationController: self, delegate: self)
    private var lastPickedCell: ImagePickerTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.reuseId)
        tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
        tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
        tableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
        tableView.register(ImagePickerTableViewCell.self, forCellReuseIdentifier: ImagePickerTableViewCell.reuseId)
        tableView.register(JustTextTableViewCell.self, forCellReuseIdentifier: JustTextTableViewCell.reuseId)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
        tableView.register(SegmentControlTableViewCell.self, forCellReuseIdentifier: SegmentControlTableViewCell.reuseId)
        
		self.setObservers()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
		registerDatasource.prepareMasterData(with: nil, presentAlertOn: self) { _ in
			self.formData = self.prepareFormData()
			
			self.tableView.reloadData()
		}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func cancelTapped() {
        registerDatasource.cancelRegisterUpload()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func prepareFormData() -> [FormCellType] {
        var allCountries = [String]()
        var allIDCards = [String]()
        var allGender = [String]()
        var genderString = ""

        if let masterData = registerDatasource.masterData {
			allCountries = masterData.country?.compactMap({
                return "(\($0.alias ?? "")) \($0.code ?? "")"
			}) ?? []
            
            allIDCards = masterData.proof?.map({
                return $0.proof ?? ""
            }) ?? []
			
            allGender = masterData.gender?.map({
                return ($0.gender ?? "")
            }) ?? []
            
            genderString = masterData.gender?.first(where: {
                $0.id == registerUserModel.gender
            })?.gender ?? ""
        }
        
        if self.registerUserModel.isdCode.isEmpty, allCountries.count > 0 {
            // Select India by default
            self.registerUserModel.isdCodeDisplay = allCountries[0]
            self.registerUserModel.isdCode = registerDatasource.masterData?.country?[0].code ?? ""
        }
        
        let startedText = NSMutableAttributedString(string:"Let's get\n", attributes: [NSAttributedString.Key.font: AppFont.PoppinsMedium(size: 26), NSAttributedString.Key.foregroundColor : AppColor.PurpleColor()])
        
        let tempString = NSMutableAttributedString(string:"Started", attributes: [NSAttributedString.Key.font : AppFont.PoppinsBold(size: 32), NSAttributedString.Key.foregroundColor : AppColor.OrangeColor()])
        
        startedText.append(tempString)
        
        let termsString = NSMutableAttributedString(string: "By clicking Let's Go, you agree to the Privacy Policy and Our Terms and Conditions", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        termsString.addAttribute(.link, value: termsandConditionUrl, range: NSRange(location: 34, length: 48))
        
        let formData: [FormCellType] = [
            .attrText(startedText, .center),
            .segment,
            .textEdit(TextEditModel(key: "fullName", textValue: registerUserModel.fullName, contextText: "Full Name", placeHolder: "Full Name", isSecure: false)),
            .textPicker(TextPickerModel(key: "isdCode", textValue: registerUserModel.isdCodeDisplay, allValues: allCountries, contextText: "Country Code")),
            .textEdit(TextEditModel(key: "mobileNumber", textValue: registerUserModel.mobileNumber, contextText: "Mobile Number", placeHolder: "Mobile Number", keyboardType: .phonePad, isSecure: false)),
            .textPicker(TextPickerModel(key: "gender", textValue: genderString, allValues: allGender, contextText: "Gender", placeHolder: "Select Gender")),
            .textEdit(TextEditModel(key: "emailID", textValue: registerUserModel.emailID, contextText: "Email ID", placeHolder: "Email ID", keyboardType: .emailAddress, isSecure: false)),
            .date(DatePickerModel(key: "dob", minDate: nil, maxDate: Date(), dateValue: registerUserModel.dateOfBirth, contextText: "Date of Birth (dd-mm-yyyy)")),
            .textEdit(TextEditModel(key: "userName", textValue: registerUserModel.userName, contextText: "Username", placeHolder: "Username allows a-z,0-9,_,.")),
            .textEdit(TextEditModel(key: "password", textValue: registerUserModel.password, contextText: "Password", placeHolder: "", keyboardType: .default, isSecure: true)),
            .textEdit(TextEditModel(key: "confirmPassword", textValue: registerUserModel.confirmPassword, contextText: "Confirm Password", placeHolder: "", keyboardType: .default, isSecure: true)),
            .textPicker(TextPickerModel(key: "idType", allValues: allIDCards, contextText: "ID Type", placeHolder: "Select ID Type")),
            .textEdit(TextEditModel(key: "idNumber", contextText: "ID Number", placeHolder: "ID Type Number", keyboardType: .numberPad, isSecure: false)),
            .text("Upload ID", .natural),
            .imagePicker(ImagePickerModel(key: "frontImage", titleText: "Click here to upload Front Side Image", contextText: "Front Image")),
            .imagePicker(ImagePickerModel(key: "backImage", titleText: "Click here to upload Back Side Image", contextText: "Back Image")),
            .toggle(ToggleViewModel(key: "terms", contextText: termsString, defaultValue: false)),
            .button("LET'S GO")
        ]
        
        return formData
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
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height-view.safeAreaInsets.bottom, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

extension SignupViewController: UITableViewDataSource, UITableViewDelegate {
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
            
        case .attrText(let text, let alignment):
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: JustTextTableViewCell.reuseId, for: indexPath) as? JustTextTableViewCell else {
                return UITableViewCell()
            }
            
            textCell.configure(nil, text, alignment: alignment)
            cell = textCell
            
        case .toggle(let model):
            guard let toggleCell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseId, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            
            toggleCell.configure(model, delegate: self)
            cell = toggleCell
            
        case .segment:
            guard let toggleCell = tableView.dequeueReusableCell(withIdentifier: SegmentControlTableViewCell.reuseId, for: indexPath) as? SegmentControlTableViewCell else {
                return UITableViewCell()
            }
            toggleCell.delegate = self
            cell = toggleCell
        }
        
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
}

extension SignupViewController: FootnoteButtonDelegate, CellDataFetchProtocol, ImagePickerCellDelegate, TextPickerDelegate, SwitchCellDelegate, SegmentCellDelegate {
    func segmentTapped(_ index: Int) {
        registerUserModel.userType = index + 1
    }
    
    func toggleValueChanged(_ key: String, value: Bool) {
        self.registerUserModel.termsAccepted = value
        updateCellFormData(key: key, value: value == true ? "true" : "false")
    }
    
    func didPickText(_ key: String, index: Int) {
        guard let codingKey = RegisterUser.CodingKeys(rawValue: key) else { return }
        
        switch codingKey {
        case .isdCode:
			if let country = registerDatasource.masterData?.country?[index] {
				self.registerUserModel.isdCodeDisplay = "(\(country.alias ?? "")) \(country.code ?? "")"
				self.registerUserModel.isdCode = country.code ?? ""
                
                self.registerDatasource.prepareMasterData(with: country.id, presentAlertOn: self) { (_) in
                    self.formData = self.prepareFormData()
                }
            }
            
        case .idType:
			if let idType = registerDatasource.masterData?.proof?[index] {
				self.registerUserModel.idType = String(idType.id ?? 0)
				updateCellFormData(key: key, value: idType.proof ?? "")
            }
        case .gender:
			if let genderType = registerDatasource.masterData?.gender?[index] {
                self.registerUserModel.gender = genderType.id ?? 0
                updateCellFormData(key: key, value: genderType.gender ?? "")
            }
            
        default:
            break
        }
    }
    
    func pickImage(_ key: String, cell: ImagePickerTableViewCell) {
        self.lastPickedCell = cell
        imagePicker.present(from: self.view)
    }
    
    func valueChanged(keyValuePair: (key: String, value: String)) {
        guard let codingKey = RegisterUser.CodingKeys(rawValue: keyValuePair.key) else { return }
        
        switch codingKey {
        case .fullName:
            self.registerUserModel.fullName = keyValuePair.value
        case .mobileNumber:
            self.registerUserModel.mobileNumber = keyValuePair.value
        case .emailID:
            self.registerUserModel.emailID = keyValuePair.value
        case .dob:
            self.registerUserModel.dob = keyValuePair.value
        case .idNumber:
            self.registerUserModel.idNumber = keyValuePair.value
        case .userName:
            self.registerUserModel.userName = keyValuePair.value
        case .password:
            self.registerUserModel.password = keyValuePair.value
        case .confirmPassword:
            self.registerUserModel.confirmPassword = keyValuePair.value
        default:
            break
        }
        
        updateCellFormData(key: keyValuePair.key, value: keyValuePair.value)
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
            case .toggle(let model):
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
        case .toggle(let model):
            return model.defaultValue = value == "true"
        default:
            break;
        }
    }
    
    func footnoteButtonCallback(_ key: String) {
        self.view.endEditing(true)
        
        let isValid = registerUserModel.validate(isIndividual: registerUserModel.userType == 1)
        
        switch isValid {
        case .invalid(let message):
            self.view.makeToast(message)
            
        case .valid:
            registerDatasource.registerUser(registerUserModel: self.registerUserModel, presentAlertOn: self, progressHandler: { (progress) in
                // Handle progress
            }) { (user) in
                // Reset fields
                self.registerUserModel = RegisterUser()
                UDHelper.setAuthToken(user.token ?? "")
                self.formData = self.prepareFormData()
                self.tableView.reloadData()
				
				self.view.makeToast("Registration successful") { [weak self] _ in
					self?.navigationController?.popViewController(animated: true)
				}
            }
        }
    }
}

extension SignupViewController: ActioPickerDelegate {
    func didSelect(url: URL?, type: String) {
        self.lastPickedCell?.model?.imageUrl = url
        self.lastPickedCell?.refreshTitleText()
        
        guard let key = self.lastPickedCell?.model?.key, let codingKey = RegisterUser.CodingKeys(rawValue: key), let url = url else { return }
        
        do {
            let mediaData = try Data(contentsOf: url)
            
            switch codingKey {
            case .frontImage:
                self.registerUserModel.frontImage = mediaData
            case .backImage:
                self.registerUserModel.backImage = mediaData
            default:
                break
            }
        }
        catch {
            print("Error when converting media to data")
        }
    }
}

private enum FormCellType {
    case date(DatePickerModel)
    case textEdit(TextEditModel)
    case textPicker(TextPickerModel)
    case button(String)
    case imagePicker(ImagePickerModel)
    case text(String, NSTextAlignment)
    case attrText(NSAttributedString, NSTextAlignment)
    case toggle(ToggleViewModel)
    case segment
}
