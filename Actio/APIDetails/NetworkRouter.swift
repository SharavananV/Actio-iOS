//
//  NetworkRouter.swift
//  Actio
//
//  Created by apple on 17/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import Alamofire

class NetworkRouter {
    static let shared = NetworkRouter()
    
    private init() {}
    
    private let session = Session()
	private let retrier = NetworkRequestRetrier()
    
    func request(_ convertible: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: retrier)
    }
}

class NetworkRequestRetrier: RequestInterceptor {
	let retryCount = 2
	
	// [Request url: Number of times retried]
	private var retriedRequests: [String: Int] = [:]
	
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Swift.Error>) -> Void) {
		completion(.success(urlRequest))
	}
	
	func retry(_ request: Request, for session: Session, dueTo error: Swift.Error, completion: @escaping (RetryResult) -> Void) {
		if let response = request.task?.response as? HTTPURLResponse {
			if let url = response.url?.absoluteString {
				if response.statusCode >= 400 {
					let existingCount = retriedRequests[url] ?? 0
					retriedRequests[url] = existingCount + 1
					
					if existingCount < retryCount {
						completion(.retry)
						
						return
					} else {
						retriedRequests.removeValue(forKey: url)
					}
				} else {
					retriedRequests.removeValue(forKey: url)
				}
			}
			
			completion(.doNotRetry)
		}
	}
}
