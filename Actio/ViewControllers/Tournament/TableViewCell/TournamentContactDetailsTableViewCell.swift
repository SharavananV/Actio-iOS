//
//  TournamentContactDetailsTableViewCell.swift
//  Actio
//
//  Created by senthil on 18/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TournamentContactDetailsTableViewCell: UITableViewCell {

    @IBOutlet var contactDetailBackgroundView: UIView!
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
    
    @IBOutlet var cellBackgroundView: UIView!
    
    @IBOutlet var contactProfileImageView: UIImageView!
    
    @IBOutlet var contactNameLabel: UILabel!
    
    @IBOutlet var contactEmailLabel: UILabel!
    
    @IBOutlet var contactMobileNumLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shadowToView(view : UIView){
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.darkGray.cgColor
    }


}

