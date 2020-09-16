//
//  GalleryCollectionViewCell.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GalleryCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        self.contentView.addSubview(imageView)
        
        return imageView
    }()
    
    func configure(imageUrl: URL?) {
        imageView.layer.cornerRadius = 5
        
        if let imageUrl = imageUrl {
            imageView.load(url: imageUrl)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
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
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0, priority: .defaultHigh)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
