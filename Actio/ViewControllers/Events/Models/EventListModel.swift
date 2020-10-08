//
//  EventModel.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

// MARK: - EventCategoryResponse
struct EventCategoryResponse: ResponseType {
	var msg: String?
	let errors: [ActioError]?
    let status: String?
    let eventCategory: [EventCategory]?
}

// MARK: - EventCategory
struct EventCategory: Codable {
    let sportsID: Int?
    let sportsName: String?
    let events: [Event]

    enum CodingKeys: String, CodingKey {
        case sportsID = "sports_id"
        case sportsName = "sports_name"
        case events
    }
}

// MARK: - Event
struct Event: Codable {
    let eventID: Int?
    let eventName, eventCategory, eventType, eventAddress: String?
    let eventStartDate, eventEndDate, eventLogo: String?
    let isRegistrationOpen: Int?

    enum CodingKeys: String, CodingKey {
        case eventID = "event_id"
        case eventName = "event_name"
        case eventCategory = "event_category"
        case eventType = "event_type"
        case eventAddress = "event_address"
        case eventStartDate = "event_start_date"
        case eventEndDate = "event_end_date"
        case eventLogo = "event_logo"
        case isRegistrationOpen = "is_registration_open"
    }
	
	enum Status: Int {
		case open = 1, closed = 2, yetToOpen = 3
		
		var displayString: String {
			switch self {
			case .open:
				return "Registration open"
			case .closed:
				return "Registration closed"
			case .yetToOpen:
				return "Registration to be open"
			}
		}
		
		var backgroundColor: UIColor {
			switch self {
			case .open:
				return #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1)
			case .closed:
				return #colorLiteral(red: 0.7803921569, green: 0, blue: 0.2235294118, alpha: 1)
			case .yetToOpen:
				return #colorLiteral(red: 1, green: 0.537254902, blue: 0.2392156863, alpha: 1)
			}
		}
	}
}
