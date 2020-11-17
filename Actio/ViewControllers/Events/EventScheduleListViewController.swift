//
//  EventScheduleListViewController.swift
//  Actio
//
//  Created by KnilaDev on 12/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventScheduleListViewController: UIViewController {

	@IBOutlet var dateCollectionView: UICollectionView!
	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var scheduleDetails: [EventSchedule]?
	private var selectedIndex: Int = 0
	
	var eventID: Int?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.tableFooterView = UIView()
		
		self.title = "Match Schedule"
		
        fetchDetails()
    }
	
	private func fetchDetails() {
		service.post(matchScheduleListUrl, parameters: ["eventID": eventID ?? 0], onView: view, shouldDismissOnError: true) { (response: EventScheduleResponse) in
			self.scheduleDetails = response.schedule
			
			// Select first schedule by default
			if self.scheduleDetails?.isEmpty == false {
				self.scheduleDetails?[self.selectedIndex].isSelected = true
				
				self.dateCollectionView.reloadData()
				self.tableView.reloadData()
			}
		}
	}
}

extension EventScheduleListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return scheduleDetails?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDateCollectionViewCell.reuseId, for: indexPath) as? EventDateCollectionViewCell else {
			return UICollectionViewCell()
		}
		
		let model = self.scheduleDetails?[indexPath.item]
		cell.configure(model)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 75, height: 75)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedIndex = indexPath.item
		
		self.scheduleDetails?.forEach({ $0.isSelected = false })
		
		let model = self.scheduleDetails?[indexPath.item]
		model?.isSelected = true
		
		collectionView.reloadData()
		tableView.reloadData()
	}
}

extension EventScheduleListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return scheduleDetails?[selectedIndex].match?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchFixtureTableViewCell.reuseId, for: indexPath) as? MatchFixtureTableViewCell else {
			return UITableViewCell()
		}
		
		let match = scheduleDetails?[selectedIndex].match?[indexPath.row]
		cell.selectionStyle = .none
		cell.configure(match)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventScheduleDetailViewController") as? EventScheduleDetailViewController {
			let match = scheduleDetails?[selectedIndex].match?[indexPath.row]
			vc.scheduleId = match?.scheduleID
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}
