//
//  EventFeedModel.swift
//  Actio
//
//  Created by senthil on 28/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Welcome
struct EventFeedResponse: Codable {
    let status, logID: String
    let master: [Master]
    let list: [FeedDetailModel]
}

// MARK: - List
struct FeedDetailModel: Codable {
    let feedID, categoryID: Int
    let category, title, shortDescription, listDescription: String
    let profileImage: String
    let images: String?
    let subscriberID: Int
    let fullName, createdDate, createdTime: String
    let myFeed: Int

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
    let categoryID: Int
    let category: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case category
    }
}
class AddFeedModel {
    
    var title, shortDescription, image, description: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case title = "title"
        case shortDescription = "shortDescription"
        case image = "image"
        case description = "description"
    }
    static func keyPath(for key: String) -> ReferenceWritableKeyPath<AddFeedModel, String>? {
        switch key {
        case "title":
            return \AddFeedModel.title
        case "shortDescription":
            return \AddFeedModel.shortDescription
        case "image":
            return \AddFeedModel.image
        case "description":
            return \AddFeedModel.description
        default:
            return nil
        }
    }
    internal init (title: String, shortDescription: String, image: String,description:String) {
        self.title = title
        self.shortDescription = shortDescription
        self.image = image
        self.description = description
    }
    convenience init() {
        self.init(title: "", shortDescription: "", image: "", description: "")
    }

    
    static func requiredFields() -> [ReferenceWritableKeyPath<AddFeedModel, String>] {
        return [\AddFeedModel.title, \AddFeedModel.description, \AddFeedModel.shortDescription]
    }
    
    func getParameters() -> [String: String] {
        var parameters = [String: String]()
        
        parameters[CodingKeys.title.rawValue] = self.title
        parameters[CodingKeys.description.rawValue] = self.description
        parameters[CodingKeys.shortDescription.rawValue] = self.shortDescription
        parameters[CodingKeys.image.rawValue] = self.image
        return parameters
    }


}
