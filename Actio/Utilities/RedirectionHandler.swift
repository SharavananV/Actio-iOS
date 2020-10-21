//
//  RedirectionHandler.swift
//  Actio
//
//  Created by senthil on 16/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class RedirectionHandler {
	static let shared = RedirectionHandler()
	
	private init() {}
	
	private var topViewController: UIViewController? {
		if let window = UIApplication.shared.delegate?.window {
			return window?.topViewController()
		}
		
		return nil
	}
	
	func redirect(with params: [String: String]) {
		if let parentId = params["p"], let childId = params["c"] {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			if let loggedInUser: LoginModelResponse = UDHelper.getData(for: .loggedInUser) {
				if !parentId.isEmpty {
					if parentId == String(loggedInUser.subscriberSeqID ?? 0), let vc = storyboard.instantiateViewController(withIdentifier: "AcceptRejectRequestViewController") as? AcceptRejectRequestViewController {
						vc.childID = childId
						vc.modalPresentationStyle = .fullScreen
						topViewController?.present(vc, animated: false, completion: nil)
					}
					else {
						if let controller = storyboard.instantiateViewController(withIdentifier: "ChildLogoutWarningViewController") as? ChildLogoutWarningViewController {
							controller.modalPresentationStyle = .fullScreen
							topViewController?.present(controller, animated: false, completion: nil)
						}
					}
				}
			}
			else {
				if let loginVc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
					loginVc.modalPresentationStyle = .fullScreen
					topViewController?.present(loginVc, animated: false, completion: nil)
				}
			}
		}
		else if let refId = Int(params["f"] ?? "0"), let screen = params["screen"] {
			switch screen {
			case "T":
				guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TournamentDetailsViewController") as? TournamentDetailsViewController else {
					return
				}
				vc.tournamentId = refId
				let container = RedirectContainerViewController(rootViewController: vc)
				container.modalPresentationStyle = .fullScreen
				
				topViewController?.present(container, animated: false, completion: nil)
				
			case "E":
				guard let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController else {
					return
				}
				vc.eventId = refId
				let container = RedirectContainerViewController(rootViewController: vc)
				container.modalPresentationStyle = .fullScreen
				
				topViewController?.present(container, animated: false, completion: nil)
				
			case "F":
				guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedDetailsViewController") as? FeedDetailsViewController else {
					return
				}
				vc.feedId = refId
				let container = RedirectContainerViewController(rootViewController: vc)
				container.modalPresentationStyle = .fullScreen
				
				topViewController?.present(container, animated: false, completion: nil)
				
			default:
				break
			}
		}
	}
}
