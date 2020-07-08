//
//  TextPickerTableViewCell.swift
//  MoveCo
//
//  Created by Arun Eswaramurthi on 21/05/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class TextPickerTableViewCell: UITableViewCell {
    static let reuseId = "TextPickerTableViewCell"
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
        
        return textField
    }()
    
    private var imageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tintColor = .black
        
        let image = UIImage(named: "down")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        
        return button
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
        setupToolBar()
    }
    
    private func setConstraints() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(textField)
        
        let constraints = [
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kInternalPadding),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
            
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kInternalPadding),
            textField.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: .kInternalPadding),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        imageButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        imageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        textField.rightView = imageButton
        textField.rightViewMode = .always
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private lazy var textPicker: UIPickerView = {
        let textPicker = UIPickerView()
        textPicker.dataSource = self
        textPicker.delegate = self
        
        return textPicker
    }()
    
    private func setupToolBar() {
        self.textField.inputView = textPicker
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }
    }
    
    // MARK: Data manipulation
    var model: TextPickerModel?
    
    func configure(_ model: TextPickerModel) {
        self.model = model
        
        textField.text = model.textValue
        contentLabel.text = model.contextText
        textField.placeholder = model.placeHolder
    }
}

extension TextPickerTableViewCell: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.model?.allValues?.count == 0 { return }
        
        let timeValue = self.model?.textValue?.isEmpty == false ? self.model?.textValue : self.model?.allValues?[0]
        textField.text = timeValue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let key = self.model?.key, let value = textField.text {
            delegate?.valueChanged(keyValuePair: (key, value))
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.model?.allValues?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.model?.allValues?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let value = self.model?.allValues?[row] {
            self.textField.text = value
            self.model?.textValue = value
        }
    }
    
    func clearData() {
        textField.text = nil
    }
}

class TextPickerModel {
    var key: String?
    var textValue: String?
    var placeHolder: String?
    
    var allValues: [String]?
    var contextText: String?
    
    init(key: String, textValue: String? = nil, allValues: [String], contextText: String, placeHolder: String? = nil) {
        self.key = key
        self.textValue = textValue
        self.allValues = allValues
        self.contextText = contextText
        self.placeHolder = placeHolder
    }
}
