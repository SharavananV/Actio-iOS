//
//  PerformanceReviewListViewController.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class PerformanceReviewListViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var reviewerList: [Reviewer]?
	private var userRole: Int?
	private var actioEvents: [ActioEvent]?
	private var nonActioEvents: [NonActioEvent]?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		tableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
		self.title = "Performance Review"
		
        fetchDetails()
    }
    
	private func fetchDetails() {
		service.post(performanceReviewerListUrl, parameters: nil, onView: view) { (response: ReviewerListResponse) in
			self.reviewerList = response.list
			
			self.tableView.reloadData()
		}
	}
	
	private func fetchReviewItems() {
		service.post(performanceReviewListUrl, parameters: ["reviewer": userRole ?? 1], onView: view) { (response: PerformanceReviewListResponse) in
			self.actioEvents = response.list?.actioEvents
			self.nonActioEvents = response.list?.nonActioEvents
			
			self.tableView.reloadData()
		}
	}
}

extension PerformanceReviewListViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var title: String? = nil
		switch section {
		case 1:
			title = "Actio Events"
		case 2:
			title = "Non Actio Events"
		default:
			title = nil
		}
		
		let headerLabel = PaddingLabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
		headerLabel.insets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 5)
		headerLabel.font = AppFont.PoppinsRegular(size: 15)
		headerLabel.backgroundColor = .clear
		headerLabel.text = title

		return headerLabel
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 1:
			if self.actioEvents == nil || self.actioEvents?.count == 0 {
				return 150
			}
		case 2:
			if self.nonActioEvents == nil || self.nonActioEvents?.count == 0 {
				return 150
			}
		default:
			break
		}
		
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			if self.actioEvents == nil || self.actioEvents?.count != 0 {
				return self.actioEvents?.count ?? 1
			}
		case 2:
			if self.nonActioEvents == nil || self.nonActioEvents?.count != 0 {
				return self.nonActioEvents?.count ?? 1
			}
		default:
			break
		}
		
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			guard let textPickerCell = tableView.dequeueReusableCell(withIdentifier: TextPickerTableViewCell.reuseId, for: indexPath) as? TextPickerTableViewCell else {
				return UITableViewCell()
			}
			
			let model = roleSelectModel()
			textPickerCell.configure(model)
			textPickerCell.delegate = self
			textPickerCell.selectionStyle = .none
			
			return textPickerCell
			
		case 1:
			if let actioEvents = self.actioEvents, !actioEvents.isEmpty, let cell = tableView.dequeueReusableCell(withIdentifier: ActioKPITableViewCell.reuseId, for: indexPath) as? ActioKPITableViewCell {
				cell.configure(actioEvents[indexPath.row])
				cell.selectionStyle = .none
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "NoEventCell", for: indexPath)
				cell.selectionStyle = .none
				
				return cell
			}
			
		case 2:
			if let nonActioEvents = self.nonActioEvents, !nonActioEvents.isEmpty, let cell = tableView.dequeueReusableCell(withIdentifier: NonActioKPITableViewCell.reuseId, for: indexPath) as? NonActioKPITableViewCell {
				cell.configure(nonActioEvents[indexPath.row])
				cell.selectionStyle = .none
				
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "NoEventCell", for: indexPath)
				cell.selectionStyle = .none
				
				return cell
			}
			
		default:
			break
		}
		
		return UITableViewCell()
	}
	
	private func roleSelectModel() -> TextPickerModel {
		let selectedUser = reviewerList?.first(where: {
			$0.id == userRole
		})
		
		let allRoles = reviewerList?.compactMap { $0.name } ?? []
		return TextPickerModel(key: "userRole", textValue: selectedUser?.name, allValues: allRoles, contextText: "User Role", placeHolder: "Coach", actioField: false)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 1:
			if userRole == 1, let event = self.actioEvents?[indexPath.row] {
				if event.eventStatus == .revalidate {
					if let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "ActioEventKPIViewController") as? ActioEventKPIViewController {
						vc.updateEventDetails = event
						vc.fromScreen = .update
						
						self.navigationController?.pushViewController(vc, animated: true)
					}
				} else {
					view.makeToast("Not allowed")
				}
			} else {
				// Coach tapped
			}
				
		case 2:
			if userRole == 1, let event = self.actioEvents?[indexPath.row] {
				if event.eventStatus == .revalidate {
					// User update tapped for non actio
				} else {
					view.makeToast("Not allowed")
				}
			} else {
				// Coach tapped
			}
			
		default:
			break
		}
	}
}

extension PerformanceReviewListViewController: TextPickerDelegate {
	func didPickText(_ key: String, index: Int) {
		self.userRole = reviewerList?[index].id
		
		self.fetchReviewItems()
	}
}
