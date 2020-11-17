//
//  FromToDatePickerTableViewCell.swift
//  Actio
//
//  Created by KnilaDev on 05/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class FromToDatePickerTableViewCell: UITableViewCell {
	static let reuseId = "FromToDatePickerTableViewCell"
	weak var delegate: CellDataFetchProtocol?
	
	// MARK: - UIRelated
	private lazy var fromLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 15)
		label.textColor = .darkGray
		label.numberOfLines = 0
		label.setContentHuggingPriority(.required, for: .horizontal)
		label.setContentHuggingPriority(.required, for: .vertical)
		label.text = "From Date"
		
		return label
	}()
	
	private lazy var fromTextField: UITextField = {
		let textField = ActioTextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = AppFont.PoppinsMedium(size: 17)
		textField.delegate = self
		
		return textField
	}()
	
	private lazy var toLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 15)
		label.textColor = .darkGray
		label.numberOfLines = 0
		label.setContentHuggingPriority(.required, for: .horizontal)
		label.setContentHuggingPriority(.required, for: .vertical)
		label.text = "To Date"
		
		return label
	}()
	
	private lazy var toTextField: UITextField = {
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
		contentView.addSubview(fromLabel)
		contentView.addSubview(fromTextField)
		contentView.addSubview(toLabel)
		contentView.addSubview(toTextField)
		
		let constraints = [
			fromLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
			fromLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
			fromLabel.trailingAnchor.constraint(equalTo: toLabel.leadingAnchor, constant: -.kInternalPadding),
			fromLabel.widthAnchor.constraint(equalTo: toLabel.widthAnchor),
			
			fromTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
			fromTextField.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 5),
			fromTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding),
			fromTextField.trailingAnchor.constraint(equalTo: toTextField.leadingAnchor, constant: -.kInternalPadding),
			fromTextField.widthAnchor.constraint(equalTo: toTextField.widthAnchor),
			
			toLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
			toLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
			
			toTextField.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 5),
			toTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding),
			toTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding)
		]
		
		NSLayoutConstraint.activate(constraints)
	}
	
	private lazy var fromDatePicker: UIDatePicker = {
		let datePicker = UIDatePicker(frame: .zero)
		datePicker.backgroundColor = UIColor.white
		datePicker.minimumDate = Date()
		datePicker.datePickerMode = UIDatePicker.Mode.date
		datePicker.addTarget(self, action: #selector(datePicked(_:)), for: .valueChanged)
		
		return datePicker
	}()
	
	private lazy var toDatePicker: UIDatePicker = {
		let datePicker = UIDatePicker(frame: .zero)
		datePicker.backgroundColor = UIColor.white
		datePicker.minimumDate = Date()
		datePicker.datePickerMode = UIDatePicker.Mode.date
		datePicker.addTarget(self, action: #selector(datePicked(_:)), for: .valueChanged)
		
		return datePicker
	}()
	
	private func setupToolBar() {
		fromTextField.inputView = self.fromDatePicker
		toTextField.inputView = self.toDatePicker
	}
	
	@objc func datePicked(_ sender: UIDatePicker) {
		if sender == fromDatePicker {
			fromTextField.text = sender.date.ddMMyyyy
			self.model?.fromDate = sender.date
			
			toDatePicker.minimumDate = self.model?.fromDate
		} else {
			toTextField.text = sender.date.ddMMyyyy
			self.model?.toDate = sender.date
		}
	}
	
	// MARK: Data manipulation
	var model: FromToDatePickerModel?
	
	func configure(_ model: FromToDatePickerModel) {
		self.model = model
		
		fromDatePicker.minimumDate = model.minDate
		fromDatePicker.maximumDate = model.maxDate
		toDatePicker.minimumDate = model.minDate
		toDatePicker.maximumDate = model.maxDate
		
		if let defaultDate = model.fromDate {
			fromDatePicker.date = defaultDate
			fromTextField.text = defaultDate.ddMMyyyy
		} else {
			fromTextField.text = nil
		}
		if let defaultDate = model.toDate {
			toDatePicker.date = defaultDate
			toTextField.text = defaultDate.ddMMyyyy
		} else {
			toTextField.text = nil
		}
		
		fromTextField.isUserInteractionEnabled = model.isEnabled
		toTextField.isUserInteractionEnabled = model.isEnabled
	}
}

extension FromToDatePickerTableViewCell: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == fromTextField {
			let date = self.model?.fromDate ?? fromDatePicker.date
			textField.text = date.ddMMyyyy
		}
		if textField == toTextField {
			let date = self.model?.toDate ?? toDatePicker.date
			textField.text = date.ddMMyyyy
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		let key = textField == fromTextField ? model?.fromKey : model?.toKey
		if let key = key, let value = textField.text {
			delegate?.valueChanged(keyValuePair: (key: key, value: value))
		}
	}
}

class FromToDatePickerModel {
	var fromKey: String?
	var toKey: String?
	var fromDate: Date?
	var toDate: Date?
	
	var minDate: Date?
	var maxDate: Date?
	
	var isEnabled: Bool = true
	
	init(fromKey: String, toKey: String?, minDate: Date? = nil, maxDate: Date? = nil, fromDate: Date? = nil, toDate: Date? = nil, isEnabled: Bool = true) {
		self.fromKey = fromKey
		self.toKey = toKey
		self.minDate = minDate
		self.maxDate = maxDate
		self.fromDate = fromDate
		self.toDate = toDate
		self.isEnabled = isEnabled
	}
}
