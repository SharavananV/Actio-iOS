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
    
    func request(_ convertible: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}
