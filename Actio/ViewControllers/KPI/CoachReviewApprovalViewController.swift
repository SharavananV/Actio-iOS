//
//  CoachReviewApprovalViewController.swift
//  Actio
//
//  Created by KnilaDev on 11/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class CoachReviewApprovalViewController: UIViewController {
	
	@IBOutlet var tournamentNameLabel: UILabel!
	@IBOutlet var eventnameLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var venueLabel: UILabel!
	@IBOutlet var playerNameLabel: UILabel!
	@IBOutlet var detailsStackView: UIStackView!
	
	private let service = DependencyProvider.shared.networkService
	private var kpiDetails: CoachReviewDetails?
	
	var eventId, kpiId, eventKpiType, status: Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Coach Approval"
		
        fetchDetails()
    }
	
	private func fetchDetails() {
		let params = [
			"eventID": eventId ?? 0,
			"kpiID": kpiId ?? 0,
			"event_kpi_type": eventKpiType ?? 0
		]
		
		service.post(getEventKPIForCoachUrl, parameters: params, onView: view) { (response: CoachReviewDetailsResponse) in
			self.kpiDetails = response.result
			
			self.tournamentNameLabel.text = self.kpiDetails?.tournamentName
			self.eventnameLabel.text = self.kpiDetails?.eventName
			self.venueLabel.text = self.kpiDetails?.eventVenue
			self.playerNameLabel.text = self.kpiDetails?.eventPlayerName
			
			if let startDate = self.kpiDetails?.eventStartDate, let endDate = self.kpiDetails?.eventEndDate {
				self.dateLabel.text = startDate + " - " + endDate
			}
			
			self.kpiDetails?.eventKpi?.forEach({ (model) in
				let kpiDetailsView = self.getKPIDetailsCell(model)
				self.detailsStackView.addArrangedSubview(kpiDetailsView)
			})
		}
	}
	
	private func getKPIDetailsCell(_ model: EventKpi) -> TextEditTableViewCell {
		let kpiDetailsView = TextEditTableViewCell()
		let details = TextEditModel(key: "key", textValue: model.kpiCategoryValue, contextText: model.kpiCategoryName ?? "", placeHolder: nil, keyboardType: .default, isSecure: false, enabled: false, actioField: false)
		kpiDetailsView.configure(details)
		
		return kpiDetailsView
	}
	
	private func submitReviewerAction(_ status: Int?, reason: String? = nil) {
		let params: [String : Any] = [
			"status": status ?? 0,
			"kpiID": kpiId ?? 0,
			"event_kpi_type": eventKpiType ?? 0,
			"remarks": reason ?? ""
		]
		
		service.post(submitReviewerActionUrl, parameters: params, onView: view) { _ in
			self.navigationController?.popToRootViewController(animated: true)
		}
	}
	
	@IBAction func validateAction(_ sender: Any) {
		let alertController = UIAlertController(title: "Confirm", message: "Are you sure, you want to approve?", preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
			self.submitReviewerAction(4)
		}
		alertController.addAction(okAction)
		
		let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	@IBAction func reValidateAction(_ sender: Any) {
		self.status = 3
		showReasonAlert()
	}
	
	@IBAction func dropAction(_ sender: Any) {
		self.status = 2
		showReasonAlert()
	}
	
	private func showReasonAlert() {
		if let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "ShowKPIReasonViewController") as? ShowKPIReasonViewController {
			vc.modalPresentationStyle = .overFullScreen
			vc.modalTransitionStyle = .crossDissolve
			vc.delegate = self
			
			self.present(vc, animated: true, completion: nil)
		}
	}
}

extension CoachReviewApprovalViewController: SendReasonProtocol {
	func sendReason(_ message: String?) {
		submitReviewerAction(self.status, reason: message)
	}
}
