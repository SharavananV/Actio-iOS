//
//  EventListHeaderCell.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventListHeaderCell: UITableViewCell {
	@IBOutlet var sectionTitleLabel: PaddingLabel!
	static let reuseId = "EventListHeaderCell"
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		sectionTitleLabel.insets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
		sectionTitleLabel.layoutIfNeeded()
    }
	
	func configure(_ title: String?) {
		sectionTitleLabel.text = title
	}
}
