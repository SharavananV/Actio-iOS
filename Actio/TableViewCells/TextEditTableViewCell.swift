//
//  TextEditTableViewCell.swift
//  MoveCo
//
//  Created by Arun Eswaramurthi on 21/05/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class TextEditTableViewCell: UITableViewCell {
    static let reuseId = "TextEditTableViewCell"
    weak var delegate: CellDataFetchProtocol?

    // MARK: - UIRelated
    private lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.PoppinsMedium(size: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = ActioTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = AppFont.PoppinsMedium(size: 17)
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setConstraints()
    }
    
    private func setConstraints() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(textField)
        
        let constraints = [
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
            
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
            textField.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: .kInternalPadding),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Data manipulation
    var model: TextEditModel?
    
    func configure(_ model: TextEditModel) {
        self.model = model
        
        contentLabel.text = model.contextText
        textField.text = model.textValue
        textField.placeholder = model.placeHolder
        textField.keyboardType = self.model?.keyBoardType ?? .default
        textField.isSecureTextEntry = model.isSecure
        
        if let type = self.model?.keyBoardType, type == .phonePad {
            textField.text = formattedNumber(number: model.textValue ?? "")
        }
    }
    
    func clearData() {
        textField.text = nil
    }
}

extension TextEditTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let key = self.model?.key, let value = textField.text {
            if let type = self.model?.keyBoardType, type == .phonePad {
                let pureNumber = value.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
                delegate?.valueChanged(keyValuePair: (key, pureNumber))
            } else {
                delegate?.valueChanged(keyValuePair: (key, value))
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let type = self.model?.keyBoardType, type != .phonePad { return true }
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
    
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXXXXXXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

class TextEditModel {
    var key: String?
    var isSecure: Bool = false
    var textValue: String?
    var placeHolder: String?
    var keyBoardType: UIKeyboardType
    
    var contextText: String?
    
    init(key: String, textValue: String? = nil, contextText: String, placeHolder: String? = nil, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        self.key = key
        self.isSecure = isSecure
        self.textValue = textValue
        self.contextText = contextText
        self.keyBoardType = keyboardType
        self.placeHolder = placeHolder
    }
}
