//
//  TournamentSponserDatasource.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TournamentSponserDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    init(_ controller: UIViewController, affliations: [TournamentAffliation]) {
        self.controller = controller
        self.affliations = affliations
    }
    
    weak var controller: UIViewController?
    private var affliations: [TournamentAffliation]
    private lazy var itemsPerRow: CGFloat = {
        if affliations.count > 2 {
            return 2.5
        }
        
        return CGFloat(self.affliations.count)
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return affliations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.reuseId, for: indexPath) as? ImageTextCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let affliation = affliations[indexPath.item]
        if let logo = affliation.logo,let imageUrl = URL(string:  baseUrl + logo) {
            cell.configure(imageUrl: imageUrl, text: affliation.name, isIcon: false)
        }
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
}
