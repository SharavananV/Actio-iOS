//
//  AcademicYearTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AcademicYearTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var toYearTextField: UITextField!
    @IBOutlet weak var fromYearTextField: UITextField!
    static let reuseId = "AcademicYearTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        toYearTextField.delegate = self
        fromYearTextField.delegate = self
    }
	
	private var model: Institute?
	
	func configure(_ data: Institute?) {
		self.model = data
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == fromYearTextField {
			self.model?.academicFromYear = Int(textField.text ?? "0")
		} else {
			self.model?.academicToYear = Int(textField.text ?? "0")
		}
	}
}
