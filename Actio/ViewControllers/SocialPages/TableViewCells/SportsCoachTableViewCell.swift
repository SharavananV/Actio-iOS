//
//  SportsCoachTableViewCell.swift
//  Actio
//
//  Created by apple on 20/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class SportsCoachTableViewCell: UITableViewCell {
    @IBOutlet weak var coachSelectSportTextField: UITextField!
    @IBOutlet weak var aboutCoachingTextField: UITextField!
    @IBOutlet weak var localityTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    static let reuseId = "SportsCoachTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
