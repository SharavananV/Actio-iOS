//
//  ForgotModel.swift
//  Actio
//
//  Created by apple on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
// MARK: - ForgotUsernameResponse
struct ForgotUsernameResponse: ResponseType {
	var msg: String?
	let errors: [ActioError]?
    let status: String?
    let result: ForgotUsernameModel?
}

// MARK: - ForgotUsernameModel
struct ForgotUsernameModel: Codable {
    let username, subscriberID: String?

    enum CodingKeys: String, CodingKey {
        case username
        case subscriberID = "subscriber_id"
    }
}
// MARK: - ForgotPasswordModel
struct ForgotPasswordModel: ResponseType {
	let errors: [ActioError]?
	var status, msg, username: String?
}
// MARK: - UpdatePasswordModel

struct UpdatePasswordModel: ResponseType {
	let errors: [ActioError]?
	var status, msg: String?
}

