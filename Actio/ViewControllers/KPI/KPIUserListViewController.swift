//
//  KPIUserListViewController.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class KPIUserListViewController: UIViewController {
	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var allPlayers: [PlayerKPIDetail]?
	private var eventName: String?
	
	var eventId: Int?
	var eventKpiType: Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
		self.title = "Performance Review"

        fetchDetails()
    }
	
	private func fetchDetails() {
		service.post(performanceCoachReviewListUrl, parameters: ["eventID": eventId ?? 0, "event_kpi_type": eventKpiType ?? 0], onView: view, shouldDismissOnError: true) { (response: PerformanceCoachReviewListResponse) in
			self.allPlayers = response.result?.list
			self.eventName = response.result?.eventName
			
			self.tableView.reloadData()
		}
	}
}

extension KPIUserListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerLabel = PaddingLabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
		headerLabel.insets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 5)
		headerLabel.font = AppFont.PoppinsRegular(size: 15)
		headerLabel.backgroundColor = .clear
		headerLabel.text = eventName
		
		return headerLabel
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allPlayers?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: KPIUserTableViewCell.reuseId, for: indexPath) as? KPIUserTableViewCell else {
			return UITableViewCell()
		}
		
		cell.configure(allPlayers?[indexPath.row])
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let player = allPlayers?[indexPath.row] else {
			return
		}
		
		if let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "CoachReviewApprovalViewController") as? CoachReviewApprovalViewController {
			vc.eventId = eventId
			vc.eventKpiType = eventKpiType
			vc.kpiId = player.kpiID
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}
