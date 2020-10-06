//
//  EventAddPlayerTableViewCell.swift
//  Actio
//
//  Created by senthil on 06/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventAddPlayerTableViewCell: UITableViewCell {
	static let reuseId = "EventAddPlayerTableViewCell"
	
	// MARK: - UIRelated
	private lazy var nameLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 15)
		label.textColor = .white
		
		return label
	}()
	
	private lazy var dobLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 15)
		label.textColor = .white
		
		return label
	}()
	
	private lazy var mobileLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 15)
		label.textColor = .white
		
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func commonInit() {
		setConstraints()
	}
	
	private func setConstraints() {
		contentView.addSubview(nameLabel)
		contentView.addSubview(dobLabel)
		contentView.addSubview(mobileLabel)
		
		let margins = contentView.safeAreaLayoutGuide
		
		let constraints = [
			nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			nameLabel.topAnchor.constraint(equalTo: margins.topAnchor),
			
			dobLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			dobLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			dobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -10),
			
			mobileLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			mobileLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			mobileLabel.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: -10),
			mobileLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
		]
		
		NSLayoutConstraint.activate(constraints)
	}

}
