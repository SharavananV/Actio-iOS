//
//  ImagePickerTableViewCell.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol ImagePickerCellDelegate: class {
    func pickImage(_ key: String, cell: ImagePickerTableViewCell)
}

class ImagePickerTableViewCell: UITableViewCell {
    static let reuseId = "ImagePickerTableViewCell"
    private weak var delegate: ImagePickerCellDelegate?
    
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
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
            
            footnoteButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: .kInternalPadding),
            footnoteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
            footnoteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding),
            footnoteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding)
        ]
        
        contentView.bringSubviewToFront(footnoteButton)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    var model: ImagePickerModel?
    
    func configure(_ model: ImagePickerModel, delegate: ImagePickerCellDelegate) {
        self.model = model
        self.delegate = delegate
        
        self.refreshTitleText()
        contentLabel.text = model.contextText
    }
    
    func refreshTitleText() {
        if let url = model?.imageUrl {
            footnoteButton.setTitle(url.absoluteString, for: .normal)
        } else {
            footnoteButton.setTitle(model?.titleText, for: .normal)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.pickImage(model?.key ?? "", cell: self)
    }
}

class ImagePickerModel {
    var key: String?
    var titleText: String?
    var contextText: String?
    var imageUrl: URL?
    
    internal init(key: String?, titleText: String?, contextText: String?) {
        self.key = key
        self.titleText = titleText
        self.contextText = contextText
    }
}
