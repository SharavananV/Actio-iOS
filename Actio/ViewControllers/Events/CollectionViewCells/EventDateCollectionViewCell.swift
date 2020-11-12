//
//  EventDateCollectionViewCell.swift
//  Actio
//
//  Created by KnilaDev on 12/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventDateCollectionViewCell: UICollectionViewCell {
	
	static let reuseId = "EventDateCollectionViewCell"
	
	@IBOutlet var dateLabel: UILabel!
	
	func configure(_ model: EventSchedule?) {
		if let modelDate = model?.date?.toDate {
			let (month, date, year) = modelDate.splitDate()
			
			if model?.isSelected == false {
				let attrs1: [NSAttributedString.Key: Any] = [.font: AppFont.PoppinsMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3176470588, green: 0.09411764706, blue: 0.2705882353, alpha: 1)]
				
				let attrs2: [NSAttributedString.Key: Any] = [.font: AppFont.PoppinsMedium(size: 15), .foregroundColor: #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)]
				
				let completeDate = NSMutableAttributedString(string: month+"\n", attributes:attrs1)
				
				completeDate.append(
					NSMutableAttributedString(string: date+"\n", attributes:attrs2)
				)
				completeDate.append(
					NSMutableAttributedString(string: year, attributes:attrs1)
				)
				
				self.dateLabel.attributedText = completeDate
			} else {
				dateLabel.text = month + "\n" + date + "\n" + year
				dateLabel.textColor = .white
			}
		}
		
		if let isSelected = model?.isSelected {
			dateLabel.backgroundColor = isSelected ? #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1) : #colorLiteral(red: 0.9882352941, green: 0.9411764706, blue: 0.9176470588, alpha: 1)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		dateLabel.layer.cornerRadius = 10
		dateLabel.clipsToBounds = true
	}
}

class EventDateCellModel {
	var date: String?
	var isSelected: Bool = false
}
