//
//  TwoLabelTableViewCell.swift
//  Actio
//
//  Created by KnilaDev on 10/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TwoLabelTableViewCell: UITableViewCell {
	static let reuseId = "TwoLabelTableViewCell"
	
	// MARK: - UIRelated
	private lazy var leftLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 15)
		label.textColor = .darkGray
		label.numberOfLines = 0
		
		return label
	}()
	
	private lazy var rightLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 15)
		label.textColor = .gray
		label.numberOfLines = 0
		
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
	
	func setConstraints() {
		contentView.addSubview(leftLabel)
		contentView.addSubview(rightLabel)
		
		let constraints = [
			leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kInternalPadding),
			leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
			leftLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.kInternalPadding),
			
			rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: .kInternalPadding),
			rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
			rightLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.kInternalPadding),
			rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
			
			leftLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
		]
		
		NSLayoutConstraint.activate(constraints)
	}
	
	func configure(_ leftText: String?, rightText: String?) {
		leftLabel.text = leftText
		rightLabel.text = rightText
	}
}
