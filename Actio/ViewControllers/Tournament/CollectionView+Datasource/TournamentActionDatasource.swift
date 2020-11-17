//
//  TournamentActionDatasource.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol TournamentActionProtocol: UIViewController {
    func didSelectAction(_ action: TournamentActionDatasource.TournamentAction)
}

class TournamentActionDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    init(_ controller: TournamentActionProtocol) {
        self.controller = controller
    }
    
    let actions = TournamentAction.allCases
    weak var controller: TournamentActionProtocol?
    private let itemsPerRow: CGFloat = 5
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTextCollectionViewCell.reuseId, for: indexPath) as? ImageTextCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellData = actions[indexPath.item]
        cell.configure(imageName: cellData.icon, text: cellData.displayString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let controller = controller else { return CGSize.zero}
        
        let widthPerItem = (controller.view.frame.width - 2*10) / itemsPerRow
        return CGSize(width: widthPerItem, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = actions[indexPath.item]
        controller?.didSelectAction(cellData)
    }
    
    // Remove Inter Item Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    enum TournamentAction: CaseIterable {
        case organiser, eventCategory, prize, location, affillations
        
        var displayString: String {
            switch self {
            case .organiser:
                return "Organizer"
            case .eventCategory:
                return "Event Category"
            case .prize:
                return "Prize"
            case .location:
                return "Location"
            case .affillations:
                return "Affillations"
            }
        }
        
        var icon: String {
            switch self {
            case .organiser:
                return "Organizer"
            case .eventCategory:
                return "eventCategory"
            case .prize:
                return "Prize"
            case .location:
                return "Location"
            case .affillations:
                return "Affillations"
            }
        }
    }
}
