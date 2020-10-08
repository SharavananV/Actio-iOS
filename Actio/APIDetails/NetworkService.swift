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
	
	private init() {}
	
	func get<E: ResponseType>(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil, onView view: UIView, handleError: Bool = true, completion: @escaping (E)->Void) {
		actualMethod(url, method: .get, headers: headers, parameters: parameters, onView: view, handleError: handleError, completion: completion)
	}
	
	func post<E: ResponseType>(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil, onView view: UIView, handleError: Bool = true, completion: @escaping (E)->Void) {
		actualMethod(url, method: .post, headers: headers, parameters: parameters, onView: view, handleError: handleError, completion: completion)
	}
	
	private func actualMethod<E: ResponseType>(
		_ url: String, method: Method,
		headers: [String: String]? = nil,
		parameters: [String: Any]? = nil,
		onView view: UIView,
		handleError: Bool = true,
		completion: @escaping (E)->Void)
	{
		var allHeaders : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken(), "Content-Type": "application/json"]
		
		headers?.forEach { (key, value) in
			allHeaders.add(name: key, value: value)
		}
		
		ActioSpinner.shared.show(on: view)
		
		NetworkRouter.shared.request(url, method: (method == .get ? .get : .post), parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).responseDecodable(of: E.self, queue: .main) { (response) in
			ActioSpinner.shared.hide()
			
			guard let value = response.value else {
				print("🥶 Error: \(String(describing: response.error))")
				view.makeToast("Network error, Try again later")
				
				return
			}
			
			if handleError, value.status == "422" {
				if let errorMessage = value.errors?.first?.msg {
					view.makeToast(errorMessage)
				} else if let errorMessage = value.msg {
					view.makeToast(errorMessage)
				}
			}
			else {
				completion(value)
			}
		}
	}
	
	func post(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil, onView view: UIView, handleError: Bool = true, completion: @escaping ([String: Any])->Void) {
		actualMethod(url, method: .post, headers: headers, parameters: parameters, onView: view, handleError: handleError, completion: completion)
	}
	
	private func actualMethod(
		_ url: String, method: Method,
		headers: [String: String]? = nil,
		parameters: [String: Any]? = nil,
		onView view: UIView,
		handleError: Bool = true,
		completion: @escaping ([String: Any])->Void)
	{
		var allHeaders : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken(), "Content-Type": "application/json"]
		
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
					if handleError, json["status"] as? String == "422", let errors = json["errors"] as? [[String: Any]], let message = errors.first?["msg"] as? String {
						view.makeToast(message)
						
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
