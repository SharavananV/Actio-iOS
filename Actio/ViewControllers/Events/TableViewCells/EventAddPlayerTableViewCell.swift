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
	
	private lazy var containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 7
		view.clipsToBounds = true
		
		return view
	}()
	
	func configure(_ player: CDPlayer) {
		nameLabel.text = player.name
		mobileLabel.text = player.mobileNumber
		dobLabel.text = player.dob
		
		containerView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
		containerView.setNeedsLayout()
	}
	
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
		contentView.addSubview(containerView)
		
		containerView.addSubview(nameLabel)
		containerView.addSubview(dobLabel)
		containerView.addSubview(mobileLabel)
				
		let constraints = [
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kExternalPadding),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kExternalPadding),
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kExternalPadding),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kExternalPadding),
			
			nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .kInternalPadding),
			nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.kInternalPadding),
			nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .kInternalPadding),
			
			dobLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .kInternalPadding),
			dobLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.kInternalPadding),
			dobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .kInternalPadding),
			
			mobileLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .kInternalPadding),
			mobileLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.kInternalPadding),
			mobileLabel.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: .kInternalPadding),
			mobileLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.kInternalPadding)
		]
		
		NSLayoutConstraint.activate(constraints)
	}

}
