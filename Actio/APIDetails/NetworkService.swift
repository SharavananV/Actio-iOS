//
//  NetworkService.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
	static let shared = NetworkService()
	private let manager = NetworkReachabilityManager(host: "www.google.com")
	
	private init() {
		manager?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { (status) in
			switch status {
			case .notReachable:
				self.showNoNetworkAvailableLabel()
			case .reachable(_):
				self.removeNoNetworkController()
			default:
				return
			}
		})
	}
	
	func post<E: ResponseType>(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil, onView view: UIView, handleError: Bool = true, shouldAddDefaultHeaders: Bool = true, shouldDismissOnError: Bool = false, completion: @escaping (E)->Void) {
		actualMethod(url, method: .post, headers: headers, parameters: parameters, onView: view, handleError: handleError, shouldAddDefaultHeaders: shouldAddDefaultHeaders,
					 shouldDismissOnError: shouldDismissOnError, completion: completion)
	}
	
	private func actualMethod<E: ResponseType>(
		_ url: String, method: Method,
		headers: [String: String]? = nil,
		parameters: [String: Any]? = nil,
		onView view: UIView,
		handleError: Bool = true,
		shouldAddDefaultHeaders: Bool = true,
		shouldDismissOnError: Bool = false,
		completion: @escaping (E)->Void)
	{
		var allHeaders : HTTPHeaders = shouldAddDefaultHeaders ? ["Authorization" : "Bearer "+UDHelper.getAuthToken(), "Content-Type": "application/json"] : [:]
		
		headers?.forEach { (key, value) in
			allHeaders.add(name: key, value: value)
		}
		
		ActioSpinner.shared.show(on: view)
		
		NetworkRouter.shared.request(url, method: (method == .get ? .get : .post), parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).responseDecodable(of: E.self, queue: .main) { (response) in
			ActioSpinner.shared.hide()
			
			guard let value = response.value else {
				print("🥶 Error: \(String(describing: response.error))")
				self.showToast("Network error, Try again later", on: view, shouldDismiss: shouldDismissOnError)
				
				return
			}
			
			if handleError, value.status == "422" {
				var message = "Something went wrong!"
				if let errorMessage = value.errors?.first?.msg {
					message = errorMessage
				} else if let errorMessage = value.msg {
					message = errorMessage
				}
				
				self.showToast(message, on: view, shouldDismiss: shouldDismissOnError)
			}
			else {
				completion(value)
			}
		}
	}
	
	func post(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil, onView view: UIView, handleError: Bool = true, shouldAddDefaultHeaders: Bool = true, completion: @escaping ([String: Any])->Void) {
		actualMethod(url, method: .post, headers: headers, parameters: parameters, onView: view, handleError: handleError, shouldAddDefaultHeaders: shouldAddDefaultHeaders, completion: completion)
	}
	
	private func actualMethod(
		_ url: String, method: Method,
		headers: [String: String]? = nil,
		parameters: [String: Any]? = nil,
		onView view: UIView,
		handleError: Bool = true,
		shouldAddDefaultHeaders: Bool = true,
		completion: @escaping ([String: Any])->Void)
	{
		var allHeaders: HTTPHeaders = shouldAddDefaultHeaders ? ["Authorization" : "Bearer "+UDHelper.getAuthToken(), "Content-Type": "application/json"] : [:]
		
		headers?.forEach { (key, value) in
			allHeaders.add(name: key, value: value)
		}
		
		ActioSpinner.shared.show(on: view)
		
		NetworkRouter.shared.request(url, method: (method == .get ? .get : .post), parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).responseData { (response) in
			ActioSpinner.shared.hide()
			
			guard let data = response.data else {
				print("🥶 Error: \(String(describing: response.error))")
				view.makeToast("Network error, Try again later")
				
				return
			}
			
			do {
				if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
					if handleError, json["status"] as? String == "422" {
						if let errors = json["errors"] as? [[String: Any]], let message = errors.first?["msg"] as? String {
							view.makeToast(message)
						}
						else if let message = json["msg"] as? String {
							view.makeToast(message)
						}
						else {
							view.makeToast("Something went wrong!")
						}
						
						return
					} else {
						completion(json)
					}
				}
			} catch {
				print("Error decoding data")
			}
		}
	}
	
	private func showToast(_ message: String, on view: UIView, shouldDismiss: Bool) {
		view.makeToast(message, duration: 2) {_ in
			if !shouldDismiss { return }
			
			let parentVC = view.parentViewController
			if let nav = parentVC?.navigationController {
				if nav.viewControllers.first == parentVC {
					nav.dismiss(animated: false, completion: nil)
				} else {
					nav.popViewController(animated: false)
				}
			} else {
				parentVC?.dismiss(animated: false, completion: nil)
			}
		}
	}
	
	private func showNoNetworkAvailableLabel() {
		if let window = UIApplication.shared.delegate?.window, let currentController = window?.topViewController() {
			let vc = UIStoryboard(name: "Social", bundle: nil).instantiateViewController(withIdentifier: "InternetConnectionView")
			vc.modalPresentationStyle = .fullScreen
			currentController.present(vc, animated: false, completion: nil)
		}
	}
	
	private func removeNoNetworkController() {
		if let window = UIApplication.shared.delegate?.window, let currentController = window?.topViewController(), currentController.restorationIdentifier == "InternetConnectionView" {
			currentController.dismiss(animated: false, completion: nil)
		}
	}

	private enum Method {
		case get, post
	}
}

protocol ResponseType: Codable {
	var status: String? { get }
	var errors: [ActioError]? { get }
	var msg: String? { get }
}

// MARK: - ErrorElement
struct ActioError: Codable {
	var msg: String?
}
