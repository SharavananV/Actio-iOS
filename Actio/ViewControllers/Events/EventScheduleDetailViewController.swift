//
//  EventScheduleDetailViewController.swift
//  Actio
//
//  Created by KnilaDev on 12/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventScheduleDetailViewController: UIViewController {

	@IBOutlet var scoreBoardView: UIView!
	@IBOutlet var team1Label: UILabel!
	@IBOutlet var team2Label: UILabel!
	@IBOutlet var team1Score: UILabel!
	@IBOutlet var team2Score: UILabel!
	@IBOutlet var venueLabel: UILabel!
	@IBOutlet var matchType: UILabel!
	@IBOutlet var segmentControl: UISegmentedControl!
	@IBOutlet var tableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
	private var matchDetails: Match?
	private var firstSegmentDetails: [[String: String?]]?
	private var secondSegmentDetails: [Any]?
	private var thirdSegmentDetails: [Any]?
	
	var scheduleId: Int?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.register(TwoLabelTableViewCell.self, forCellReuseIdentifier: TwoLabelTableViewCell.reuseId)
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		
		self.title = "Match Details"

		prepareUI()
        fetchDetails()
    }
	
	private func fetchDetails() {
		service.post(matchScheduleDetailsUrl, parameters: ["scheduleID": scheduleId ?? 0], onView: view, shouldDismissOnError: true) { (response: EventScheduleDetailResponse) in
			self.matchDetails = response.match
			self.updateUI()
			
			self.firstSegmentDetails = self.prepareMatchDetails()
			self.secondSegmentDetails = [
				["Manager": self.matchDetails?.competitorRegisterBy],
				["Coach": self.matchDetails?.competitorCoach]
			]
			let team1PlayerList = self.matchDetails?.competitorTeam?.compactMap { return $0.fullName } ?? []
			self.secondSegmentDetails?.append(contentsOf: team1PlayerList)
			
			self.thirdSegmentDetails = [
				["Manager": self.matchDetails?.opponentRegisterBy],
				["Coach": self.matchDetails?.opponentCoach]
			]
			let team2PlayerList = self.matchDetails?.opponentTeam?.compactMap { return $0.fullName } ?? []
			self.thirdSegmentDetails?.append(contentsOf: team2PlayerList)
			
			self.tableView.reloadData()
		}
	}
	
	@IBAction func updateSegmentDetails(_ sender: Any) {
		tableView.reloadData()
	}
	
	private func updateUI() {
		team1Label.text = matchDetails?.competitor
		team2Label.text = matchDetails?.opponent
		team1Score.text = matchDetails?.competitorScore
		team2Score.text = matchDetails?.oponentScore
		venueLabel.text = matchDetails?.venueName
		matchType.text = matchDetails?.matchType
	}
	
	private func prepareUI() {
		scoreBoardView.layer.cornerRadius = 10
		scoreBoardView.layer.masksToBounds = true
		
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		scoreBoardView.applyGradientFromTop(colours: [#colorLiteral(red: 0.7803921569, green: 0, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)])
	}
}

extension EventScheduleDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch segmentControl.selectedSegmentIndex {
		case 0:
			return self.firstSegmentDetails?.count ?? 0
			
		case 1:
			return self.secondSegmentDetails?.count ?? 0
			
		case 2:
			return self.thirdSegmentDetails?.count ?? 0
			
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch segmentControl.selectedSegmentIndex {
		case 0:
			if let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelTableViewCell.reuseId, for: indexPath) as? TwoLabelTableViewCell {
				if let data = self.firstSegmentDetails?[indexPath.row], let key = data.keys.first, let value = data[key] {
					cell.configure(key, rightText: value)
				}
				cell.selectionStyle = .none
				
				return cell
			}
			
		case 1:
			if let data = self.secondSegmentDetails?[indexPath.row] as? [String: String?] {
				if let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelTableViewCell.reuseId, for: indexPath) as? TwoLabelTableViewCell {
					if let key = data.keys.first, let value = data[key] {
						cell.configure(key, rightText: value)
					}
					cell.selectionStyle = .none
					
					return cell
				}
			} else if let data = self.secondSegmentDetails?[indexPath.row] as? String {
				if let cell = tableView.dequeueReusableCell(withIdentifier: PlayerListTableViewCell.reuseId, for: indexPath) as? PlayerListTableViewCell {
					cell.playerNameLabel.text = data
					cell.selectionStyle = .none
					
					return cell
				}
			}
			
		case 2:
			if let data = self.thirdSegmentDetails?[indexPath.row] as? [String: String?] {
				if let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelTableViewCell.reuseId, for: indexPath) as? TwoLabelTableViewCell {
					if let key = data.keys.first, let value = data[key] {
						cell.configure(key, rightText: value)
					}
					cell.selectionStyle = .none
					
					return cell
				}
			} else if let data = self.thirdSegmentDetails?[indexPath.row] as? String {
				if let cell = tableView.dequeueReusableCell(withIdentifier: PlayerListTableViewCell.reuseId, for: indexPath) as? PlayerListTableViewCell {
					cell.playerNameLabel.text = data
					cell.selectionStyle = .none
					
					return cell
				}
			}
			
		default:
			break
		}
		
		return UITableViewCell()
	}
	
	private func prepareMatchDetails() -> [[String: String?]] {
		let params: [[String: String?]] = [
			["Match Id": String(matchDetails?.venueID ?? 0)],
			["Event": matchDetails?.eventName],
			["Date": matchDetails?.matchDate],
			["Time": (matchDetails?.from ?? "") + " - " + (matchDetails?.to ?? "")],
			["Venue": matchDetails?.venueName],
			["Field": matchDetails?.venueAssetName],
			["Description": matchDetails?.matchDescription?.htmlToString],
			["Remarks": matchDetails?.changeRemarks]
		]
		
		return params.filter { (element) -> Bool in
			if let key = element.keys.first {
				return element[key] != nil
			}
			
			return false
		}
	}
}
