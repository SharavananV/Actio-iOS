//
//  RegistrationDetailSummaryCell.swift
//  Actio
//
//  Created by senthil on 07/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol EditRegistrationDelegate: class {
	func editRegistration()
}

class RegistrationDetailSummaryCell: UITableViewCell {
	
	static let reuseId = "RegistrationDetailSummaryCell"

	@IBOutlet var registrationByLabel: UILabel!
	@IBOutlet var registerAsLabel: UILabel!
	@IBOutlet var playerTypeLabel: UILabel!
	@IBOutlet var ageGroupLabel: UILabel!
	@IBOutlet var teamNameLabel: UILabel!
	@IBOutlet var countryLabel: UILabel!
	@IBOutlet var stateLabel: UILabel!
	@IBOutlet var cityLabel: UILabel!
	@IBOutlet var coachName: UILabel!
	@IBOutlet var coachMobileLabel: UILabel!
	@IBOutlet var coachEmailLabel: UILabel!
	@IBOutlet var coachStackView: UIStackView!
	@IBOutlet var superStackView: UIStackView!
	
	weak var delegate: EditRegistrationDelegate?
	
	func configure(_ data: ViewStatus) {
		registrationByLabel.text = data.registerBy
		registerAsLabel.text = data.registerAs
		playerTypeLabel.text = data.playerType
		ageGroupLabel.text = data.ageGroup
		teamNameLabel.text = data.teamName
		countryLabel.text = data.countryName
		stateLabel.text = data.stateName
		cityLabel.text = data.cityName
		
		if let coachNameString = data.coachName, let coachMobile = data.coachMobileNumber, let coachEmail = data.coachEmailID {
			coachName.text = coachNameString
			coachEmailLabel.text = coachEmail
			coachMobileLabel.text = coachMobile
		} else {
			coachStackView.removeFromSuperview()
			superStackView.removeArrangedSubview(coachStackView)
		}
	}
	
	@IBAction func editRegistrationAction(_ sender: Any) {
		delegate?.editRegistration()
	}
}
