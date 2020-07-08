//
//  SwitchTableViewCell.swift
//  Actio
//
//  Created by apple on 07/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func toggleValueChanged(_ key: String, value: Bool)
}

class SwitchTableViewCell: UITableViewCell, UITextViewDelegate {
    static let reuseId = "SwitchTableViewCell"
    weak var delegate: SwitchCellDelegate?

    // MARK: - UIRelated
    private lazy var contextTextView: SelfSizingTextView = {
        let textView = SelfSizingTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textAlignment = .justified
        
        return textView
    }()
    
    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .themeOrangeHalfAlpha
        toggle.thumbTintColor = .themeOrange
        toggle.tintColor = .themeOrange
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        
        return toggle
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
        contentView.addSubview(contextTextView)
        contentView.addSubview(toggle)
        
        let constraints = [
            contextTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kInternalPadding),
            contextTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kInternalPadding),
            contextTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.kInternalPadding),
            
            toggle.leadingAnchor.constraint(equalTo: contextTextView.trailingAnchor, constant: .kInternalPadding),
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kInternalPadding),
            toggle.centerYAnchor.constraint(equalTo: contextTextView.centerYAnchor),
            toggle.widthAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Data manipulation
    var model: ToggleViewModel?
    
    func configure(_ model: ToggleViewModel) {
        self.model = model
        
        contextTextView.attributedText = model.contextText
        toggle.setOn(model.defaultValue, animated: false)
        
        contextTextView.setNeedsLayout()
    }
    
    func clearData() {
        toggle.setOn(model?.defaultValue ?? false, animated: false)
    }
    
    @objc func toggleChanged() {
        delegate?.toggleValueChanged(model?.key ?? "", value: toggle.isOn)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}

class ToggleViewModel {
    var key: String
    var contextText: NSAttributedString
    var defaultValue: Bool
    
    internal init(key: String, contextText: NSAttributedString, defaultValue: Bool = false) {
        self.key = key
        self.contextText = contextText
        self.defaultValue = defaultValue
    }
}
