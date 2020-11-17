//
//  EventFeedModel.swift
//  Actio
//
//  Created by senthil on 28/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// MARK: - EventFeedResponse
struct EventFeedResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
    let status, logID: String?
    let master: [Master]?
	var list: DetailOrList?
}

enum DetailOrList: Codable {
	case list([FeedDetailModel]), detail(FeedDetailModel)
	
	enum CodingKeys: CodingKey {
		case list, detail
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let list = try? container.decode([FeedDetailModel].self) {
			self = .list(list)
			return
		} else if let detail = try? container.decode(FeedDetailModel.self) {
			self = .detail(detail)
			return
		} else {
			throw EncodingError.dataCorrupted("Error in decoding feed details")
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .list(let values):
			try container.encode(values, forKey: .list)
		case .detail(let value):
			try container.encode(value, forKey: .detail)
		}
	}
}

enum EncodingError: Swift.Error {
	case dataCorrupted(String)
}

// MARK: - List
struct FeedDetailModel: Codable {
    let feedID, categoryID: Int?
    let category, title, shortDescription, listDescription: String?
    let profileImage: String?
    let images: String?
    let subscriberID: Int?
    let fullName, createdDate, createdTime: String?
    let myFeed: Int?

    enum CodingKeys: String, CodingKey {
        case feedID = "feed_id"
        case categoryID = "category_id"
        case category, title
        case shortDescription = "short_description"
        case listDescription = "description"
        case images
        case profileImage = "profile_image"
        case subscriberID = "subscriber_id"
        case fullName = "full_name"
        case createdDate = "created_date"
        case createdTime = "created_time"
        case myFeed = "my_feed"
    }
}

// MARK: - Master
struct Master: Codable {
    let categoryID: Int?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case category
    }
}
