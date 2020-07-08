//
//  SignupViewController.swift
//  Actio
//
//  Created by apple on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var formData: [FormCellType]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.reuseId)
        tableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
        tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
        tableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
        tableView.register(ImagePickerTableViewCell.self, forCellReuseIdentifier: ImagePickerTableViewCell.reuseId)
        tableView.register(ImagePickerTableViewCell.self, forCellReuseIdentifier: ImagePickerTableViewCell.reuseId)
        tableView.register(JustTextTableViewCell.self, forCellReuseIdentifier: JustTextTableViewCell.reuseId)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
        
        self.formData = prepareFormData()
        self.setObservers()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func prepareFormData() -> [FormCellType] {
        let startedText = NSMutableAttributedString(string:"Let's get\n", attributes: [NSAttributedString.Key.font: AppFont.PoppinsMedium(size: 26), NSAttributedString.Key.foregroundColor : AppColor.PurpleColor()])
        
        let tempString = NSMutableAttributedString(string:"Started", attributes: [NSAttributedString.Key.font : AppFont.PoppinsBold(size: 32), NSAttributedString.Key.foregroundColor : AppColor.OrangeColor()])
        
        startedText.append(tempString)
        
        let termsString = NSMutableAttributedString(string: "By clicking Let's Go, you agree to the Privacy Policy and Our Terms and Conditions", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
        termsString.addAttribute(.link, value: "https://www.hackingwithswift.com", range: NSRange(location: 34, length: 48))
        
        let formData: [FormCellType] = [
            .attrText(startedText, .center),
            .textEdit(TextEditModel(key: "fullName", contextText: "Full Name", placeHolder: "Full Name")),
            .textPicker(TextPickerModel(key: "countryCode", textValue: nil, allValues: [], contextText: "Country Code")),
            .textEdit(TextEditModel(key: "mobile", textValue: nil, contextText: "Mobile Number", placeHolder: "Mobile Number", keyboardType: .phonePad, isSecure: false)),
            .textEdit(TextEditModel(key: "email", textValue: nil, contextText: "Email ID", placeHolder: "Email ID", keyboardType: .emailAddress, isSecure: false)),
            .date(DatePickerModel(key: "dob", minDate: nil, maxDate: Date(), dateValue: nil, contextText: "Date of Birth (dd-mm-yyyy)")),
            .textEdit(TextEditModel(key: "userName", contextText: "Username", placeHolder: "Username allows a-z,0-9,_,.")),
            .textEdit(TextEditModel(key: "password", textValue: nil, contextText: "Password", placeHolder: "", keyboardType: .default, isSecure: true)),
            .textEdit(TextEditModel(key: "confirm", textValue: nil, contextText: "Confirm Password", placeHolder: "", keyboardType: .default, isSecure: true)),
            .textPicker(TextPickerModel(key: "idType", allValues: [], contextText: "ID Type", placeHolder: "Select ID Type")),
            .textEdit(TextEditModel(key: "idNumber", textValue: nil, contextText: "ID Number", placeHolder: "ID Type Number", keyboardType: .numberPad, isSecure: false)),
            .text("Upload ID", .natural),
            .imagePicker("front", "Click here to upload Front Side Image", "Front Image"),
            .imagePicker("back", "Click here to upload Back Side Image", "Back Image"),
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
            //dateCell.delegate = self
            cell = dateCell
            
        case .textEdit(let model):
            guard let textEditCell = tableView.dequeueReusableCell(withIdentifier: TextEditTableViewCell.reuseId, for: indexPath) as? TextEditTableViewCell else {
                return UITableViewCell()
            }
            
            textEditCell.configure(model)
            //textEditCell.delegate = self
            cell = textEditCell
            
        case .textPicker(let model):
            guard let textPickerCell = tableView.dequeueReusableCell(withIdentifier: TextPickerTableViewCell.reuseId, for: indexPath) as? TextPickerTableViewCell else {
                return UITableViewCell()
            }
            
            textPickerCell.configure(model)
            //textPickerCell.delegate = self
            cell = textPickerCell
            
        case .button(let title):
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: FootnoteButtonTableViewCell.reuseId, for: indexPath) as? FootnoteButtonTableViewCell else {
                return UITableViewCell()
            }
            
            buttonCell.configure(title: title, delegate: self)
            cell = buttonCell
            
        case .imagePicker(let key, let title, let context):
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: ImagePickerTableViewCell.reuseId, for: indexPath) as? ImagePickerTableViewCell else {
                return UITableViewCell()
            }
            
            buttonCell.configure(key: key, title: title, contextText: context, delegate: self)
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
            
            toggleCell.configure(model)
            cell = toggleCell
        }
        
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
}

extension SignupViewController: FootnoteButtonDelegate {
    func footnoteButtonCallback(_ title: String) {
        
    }
}

private enum FormCellType {
    case date(DatePickerModel)
    case textEdit(TextEditModel)
    case textPicker(TextPickerModel)
    case button(String)
    case imagePicker(String, String, String)
    case text(String, NSTextAlignment)
    case attrText(NSAttributedString, NSTextAlignment)
    case toggle(ToggleViewModel)
}
