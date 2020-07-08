//
//  JustTextTableViewCell.swift
//  Actio
//
//  Created by apple on 07/07/20.
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
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kInternalPadding),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(_ title: String? = nil, _ attrText: NSAttributedString? = nil, alignment: NSTextAlignment) {
        contentLabel.text = title
        contentLabel.attributedText = attrText
        contentLabel.textAlignment = alignment
    }
}
