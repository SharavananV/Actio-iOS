//
//  NearMeTournamentListTableViewCell.swift
//  Actio
//
//  Created by senthil on 11/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class NearMeTournamentListTableViewCell: UITableViewCell {

    @IBOutlet var nearMeTournamentImage: UIImageView!
    
    @IBOutlet var nearMeTournamentNameLabel: UILabel!
    
    @IBOutlet var nearMeCalenderImage: UIImageView!
    
    @IBOutlet var nearMeLocationImage: UIImageView!
    
    @IBOutlet var nearMeDateLabel: UILabel!
    
    @IBOutlet var nearMeLocationLabel: UILabel!
    
    @IBOutlet var nearMeTournamentRegistrationStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
