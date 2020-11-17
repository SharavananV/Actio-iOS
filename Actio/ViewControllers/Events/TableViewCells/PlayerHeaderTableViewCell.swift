//
//  PlayerHeaderTableViewCell.swift
//  Actio
//
//  Created by senthil on 07/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol AddPlayerDelegate: class {
	func addPlayer()
}

class PlayerHeaderTableViewCell: UITableViewCell {
	
	static let reuseId = "PlayerHeaderTableViewCell"
	
	weak var delegate: AddPlayerDelegate?

	@IBAction func addPlayerAction(_ sender: Any) {
		self.delegate?.addPlayer()
	}
}
