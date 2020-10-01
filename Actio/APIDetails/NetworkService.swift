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
	
	func get<E: ResponseType>(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil, onView view: UIView, completion: @escaping (E)->Void) {
		actualMethod(url, method: .get, headers: headers, parameters: parameters, onView: view, completion: completion)
	}
	
	func post<E: ResponseType>(_ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = nil, onView view: UIView, completion: @escaping (E)->Void) {
		actualMethod(url, method: .post, headers: headers, parameters: parameters, onView: view, completion: completion)
	}
	
	private func actualMethod<E: ResponseType>(
		_ url: String, method: Method,
		headers: [String: String]? = nil,
		parameters: [String: Any]? = nil,
		onView view: UIView,
		completion: @escaping (E)->Void)
	{
		var allHeaders : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"", "Content-Type": "application/json"]
		
		headers?.forEach { (key, value) in
			allHeaders.add(name: key, value: value)
		}
		
		ActioSpinner.shared.show(on: view)
		
		NetworkRouter.shared.request(url, method: (method == .get ? .get : .post), parameters: parameters, encoding: JSONEncoding.default, headers: allHeaders).responseDecodable(of: E.self, queue: .main) { (response) in
			ActioSpinner.shared.hide()
			
			guard let result = response.value, result.status == "200" else {
				print("🥶 Error: \(String(describing: response.error))")
				view.makeToast(String(describing: response.error))
				
				return
			}
			
			completion(result)
		}
	}

	private enum Method {
		case get, post
	}
}

protocol ResponseType: Codable {
	var status: String? { get }
}
