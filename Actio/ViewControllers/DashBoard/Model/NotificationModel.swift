//
//  NotificationModel.swift
//  Actio
//
//  Created by senthil on 01/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - NotificationResponse
struct NotificationResponse: ResponseType {
	var msg: String?
	let errors: [ActioError]?
	let status, logID: String?
	let notification: [NotificationModel]?
}

// MARK: - Notification
struct NotificationModel: Codable {
	let fullName: String?
	let notificationID: Int?
	let message: NotificationContent?
	let seenStatus, fromID, toID: Int?
	let dateTime: String?
	
	enum CodingKeys: String, CodingKey {
		case fullName = "full_name"
		case notificationID = "notification_id"
		case message
		case seenStatus = "seen_status"
		case fromID = "from_id"
		case toID = "to_id"
		case dateTime = "date_time"
	}
}

// MARK: - NotificationContent
struct NotificationContent: Codable {
	let msg: String?
	let icon: String?
	let type: String?
	let screen: String?
}

// MARK: - Update seen response
struct UpdateSeenResponse: ResponseType {
	var msg: String?
	let errors: [ActioError]?
	var status: String?
}
