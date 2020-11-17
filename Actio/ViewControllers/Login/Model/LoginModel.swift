//
//  LoginModel.swift
//  Actio
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct LoginModelResponse: ResponseType {
	var errors: [ActioError]?
    let status, msg, token: String?
    let subscriberSeqID: Int?
    let subscriberID, userStatus, fullName, userName: String?
    let emailID, isdCode, mobileNumber: String?
    let role: Int?
}
