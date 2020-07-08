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
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func prepareFormData() -> [FormCellType] {
        
        let attributedString = NSMutableAttributedString(string: "Want to learn iOS? You should visit the best source of free iOS tutorials!")
        attributedString.addAttribute(.link, value: "https://www.hackingwithswift.com", range: NSRange(location: 19, length: 55))
        
        return [.textEdit(TextEditModel(key: "key", textValue: nil, contextText: "Full Name", placeHolder: "Full Name", keyboardType: .default, isSecure: true)), .button("Sign up"), .text("Uploda Image"), .imagePicker("front", "Click to upload the front image", "Front Image"), .toggle(ToggleViewModel(key: "toggle", contextText: attributedString))]
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
            
        case .text(let text):
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: JustTextTableViewCell.reuseId, for: indexPath) as? JustTextTableViewCell else {
                return UITableViewCell()
            }
            
            textCell.configure(text)
            cell = textCell
            
        case .toggle(let model):
            guard let toggleCell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseId, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            
            toggleCell.configure(model)
            cell = toggleCell
        }
        
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
    case text(String)
    case toggle(ToggleViewModel)
}
