//
//  ImageTextCollectionViewCell.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ImageTextCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "ImageTextCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = AppFont.PoppinsMedium(size: 12)
        label.textAlignment = .center
        
        self.contentView.addSubview(label)
        
        return label
    }()
    
    func configure(imageName: String? = nil, imageUrl: URL? = nil, text: String? = nil, isIcon: Bool = true) {
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
        }
        if let imageUrl = imageUrl {
            imageView.load(url: imageUrl)
        }
        textLabel.text = text
        
        if isIcon {
            imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        textLabel.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setConstraints()
    }
    
    private func setConstraints() {
        let constraints = [
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: 0),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10, priority: .defaultHigh)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
