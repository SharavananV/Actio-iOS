//
//  SportsPlayTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class SportsPlayTableViewCell: UITableViewCell {

    @IBOutlet weak var practiceHoursTextField: UITextField!
    @IBOutlet weak var playerSinceTextField: UITextField!
    @IBOutlet weak var selectSportTextField: UITextField!
    static let reuseId = "SportsPlayTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
