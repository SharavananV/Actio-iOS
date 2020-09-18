//
//  TournamentPrizesTableViewCell.swift
//  Actio
//
//  Created by senthil on 18/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TournamentPrizesTableViewCell: UITableViewCell {

    @IBOutlet var prizeCategoryLabel: UILabel!
    @IBOutlet var prizeValueLabel: UILabel!
    @IBOutlet var prizeLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
