//
//  FeedWithoutImageTableViewCell.swift
//  Actio
//
//  Created by apple on 15/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class FeedWithoutImageTableViewCell: UITableViewCell {

    @IBOutlet var cellBackgroundView: UIView!
        
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet var feedProfileImageView: UIImageView!
    @IBOutlet var feedTimeLabel: UILabel!
    
    @IBOutlet var feedDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.layer.masksToBounds = true

        cellBackgroundView.backgroundColor = UIColor.white
        cellBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        cellBackgroundView.layer.shadowOpacity = 0.8
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cellBackgroundView.layer.shadowRadius = 6.0
        cellBackgroundView.layer.masksToBounds = false

    }
}

