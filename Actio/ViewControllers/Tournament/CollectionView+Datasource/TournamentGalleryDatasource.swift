//
//  TournamentGalleryDatasource.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol TournamentGalleryProtocol: UIViewController {
    func didSelectPhoto(_ index: Int)
}

class TournamentGalleryDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var galleryUrls: [URL?]
    
    init(_ controller: TournamentGalleryProtocol, galleryUrls: [URL?]) {
        self.controller = controller
        self.galleryUrls = galleryUrls
    }
    
    weak var controller: TournamentGalleryProtocol?
    private let itemsPerRow: CGFloat = 2.5
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let imageUrl = galleryUrls[indexPath.item]
        cell.configure(imageUrl: imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let controller = controller else { return CGSize.zero}
        
        let padding = (itemsPerRow + 1) * 10
        let widthPerItem = (controller.view.frame.width - padding) / itemsPerRow
        return CGSize(width: widthPerItem, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller?.didSelectPhoto(indexPath.item)
    }
}
