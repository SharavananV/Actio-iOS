//
//  AcademicYearTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AcademicYearTableViewCell: UITableViewCell {

    @IBOutlet weak var toYearTextField: UITextField!
    @IBOutlet weak var fromYearTextField: UITextField!
    static let reuseId = "AcademicYearTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
