//
//  FootnoteButtonTableViewCell.swift
//  MoveCo
//
//  Created by Arun Eswaramurthi on 21/05/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

protocol FootnoteButtonDelegate: NSObject {
    func footnoteButtonCallback(_ title: String)
}

class FootnoteButtonTableViewCell: UITableViewCell {
    static let reuseId = "FootnoteButtonTableViewCell"
    private weak var delegate: FootnoteButtonDelegate?
    private let buttonHeight: CGFloat = 44
    
    private lazy var footnoteButton: ActioGradientButton = {
        let button = ActioGradientButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = self.buttonHeight / 2
        button.setTitleColor(.white, for: .normal)
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
        contentView.addSubview(footnoteButton)
        
        let constraints = [
            footnoteButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: .kInternalPadding),
            footnoteButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.kInternalPadding),
            footnoteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kExternalPadding),
            footnoteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding, priority: .defaultLow),
            footnoteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            footnoteButton.heightAnchor.constraint(equalToConstant: self.buttonHeight),
            footnoteButton.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor, multiplier: 0.5)
        ]
        
        contentView.bringSubviewToFront(footnoteButton)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(title: String, delegate: FootnoteButtonDelegate) {
        self.delegate = delegate
        footnoteButton.setTitle(title, for: .normal)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        delegate?.footnoteButtonCallback(sender.titleLabel?.text ?? "")
    }
}
