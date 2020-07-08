//
//  DatePickerTableViewCell.swift
//  MoveCo
//
//  Created by Arun Eswaramurthi on 21/05/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

protocol CellDataFetchProtocol: NSObject {
    func valueChanged(keyValuePair: (key: String, value: String))
}

protocol ClearDataProtocol {
    func clearData()
}

class DatePickerTableViewCell: UITableViewCell {
    static let reuseId = "DatePickerTableViewCell"
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
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.backgroundColor = UIColor.white
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(datePicked(_:)), for: .valueChanged)

        
        return datePicker
    }()
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    private func setupToolBar() {
        textField.inputView = self.datePicker
    }
    
    @objc func datePicked(_ sender: UIDatePicker) {
        textField.text = dateFormatter.string(from: sender.date)
        self.model?.dateValue = sender.date
    }
    
    // MARK: Data manipulation
    var model: DatePickerModel?
    
    func configure(_ model: DatePickerModel) {
        self.model = model
        
        contentLabel.text = model.contextText
        datePicker.minimumDate = model.minDate
        datePicker.maximumDate = model.maxDate
        
        if let defaultDate = model.dateValue {
            datePicker.date = defaultDate
            textField.text = dateFormatter.string(from: defaultDate)
        }
    }
    
    func clearData() {
        textField.text = nil
    }
}

extension DatePickerTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let date = self.model?.dateValue ?? datePicker.date
        textField.text = dateFormatter.string(from: date)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let key = self.model?.key, let value = textField.text {
            delegate?.valueChanged(keyValuePair: (key, value))
        }
    }
}

class DatePickerModel {
    var key: String?
    var dateValue: Date?
    
    var minDate: Date?
    var maxDate: Date?
    
    var contextText: String?
    
    init(key: String, minDate: Date? = nil, maxDate: Date? = nil, dateValue: Date? = nil, contextText: String) {
        self.key = key
        self.minDate = minDate
        self.maxDate = maxDate
        self.dateValue = dateValue
        self.contextText = contextText
    }
    
    convenience init(key: String, dateString: String? = nil, contextText: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let date = dateFormatter.date(from: dateString ?? "")
        self.init(key: key, dateValue: date, contextText: contextText)
    }
}
