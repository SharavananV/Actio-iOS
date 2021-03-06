//
//  JustTextTableViewCell.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class JustTextTableViewCell: UITableViewCell {
    static let reuseId = "JustTextTableViewCell"

    // MARK: - UIRelated
    private lazy var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.PoppinsMedium(size: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
    
	private lazy var lineView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		if #available(iOS 13.0, *) {
			view.backgroundColor = .systemGray
		} else {
			view.backgroundColor = .darkGray
		}
		
		return view
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
        contentView.addSubview(contentLabel)
        
        let constraints = [
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.kInternalPadding)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
	func configure(_ title: String? = nil, _ attrText: NSAttributedString? = nil, alignment: NSTextAlignment, _ bottomLine: Bool = false) {
        if let title = title {
            contentLabel.text = title
        } else if let attrText = attrText {
            contentLabel.attributedText = attrText
        }
        
        contentLabel.textAlignment = alignment
		
		if bottomLine {
			contentView.addSubview(lineView)
			
			let constraints = [
				lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
				lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding),
				lineView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5),
				lineView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.kInternalPadding),
				lineView.heightAnchor.constraint(equalToConstant: 1)
			]
			
			NSLayoutConstraint.activate(constraints)
		}
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		if #available(iOS 13.0, *) {
			contentLabel.textColor = .label
		} else {
			contentLabel.textColor = .darkGray
		}
	}
}
