//
//  EventActionDatasource.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol EventActionProtocol: UIViewController {
	func didSelectAction(_ action: EventActionDatasource.EventAction)
}

class EventActionDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	init(_ controller: EventActionProtocol) {
		self.controller = controller
	}
	
	let actions = EventAction.allCases
	weak var controller: EventActionProtocol?
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
	
	enum EventAction: CaseIterable {
		case matches
		
		var displayString: String {
			switch self {
			case .matches:
				return "Matches"
			}
		}
		
		var icon: String {
			switch self {
			case .matches:
				return "eventCategory"
			}
		}
	}
}
