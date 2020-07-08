//
//  ImagePickerTableViewCell.swift
//  Actio
//
//  Created by apple on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol ImagePickerCellDelegate {
    func pickImage(_ key: String)
}

class ImagePickerTableViewCell: UITableViewCell {
    static let reuseId = "ImagePickerTableViewCell"
    private weak var delegate: FootnoteButtonDelegate?
    
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
    
    private lazy var footnoteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = AppFont.PoppinsBold(size: 15)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
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
        contentView.addSubview(footnoteButton)
        
        let constraints = [
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kInternalPadding),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
            
            footnoteButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: .kExternalPadding),
            footnoteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kInternalPadding),
            footnoteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
            footnoteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding)
        ]
        
        contentView.bringSubviewToFront(footnoteButton)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    var key: String?
    
    func configure(key: String, title: String, contextText: String, delegate: FootnoteButtonDelegate) {
        self.key = key
        self.delegate = delegate
        contentLabel.text = contextText
        footnoteButton.setTitle(title, for: .normal)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.footnoteButtonCallback(key ?? "")
    }
}
