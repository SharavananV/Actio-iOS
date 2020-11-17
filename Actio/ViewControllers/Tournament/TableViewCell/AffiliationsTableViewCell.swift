//
//  AffiliationsTableViewCell.swift
//  Actio
//
//  Created by senthil on 23/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AffiliationsTableViewCell: UITableViewCell {

    @IBOutlet var affiliationsImageView: UIImageView!
    @IBOutlet var affiliationsBackgroundView: UIView!
    
    @IBOutlet var affiliationsNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        affiliationsBackgroundView.layer.cornerRadius = 10
        affiliationsBackgroundView.layer.masksToBounds = true

        affiliationsBackgroundView.backgroundColor = UIColor.white
        affiliationsBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        affiliationsBackgroundView.layer.shadowOpacity = 0.8
        affiliationsBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        affiliationsBackgroundView.layer.shadowRadius = 6.0
        affiliationsBackgroundView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
