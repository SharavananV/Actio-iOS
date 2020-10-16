//
//  Conversation.swift
//  Actio
//
//  Created by senthil on 14/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import MessageKit

// MARK: - ChatHistoryModel
struct ConversationResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status, logID: String?
	var conversation: [Conversation]?
}

// MARK: - Conversation
struct Conversation: Codable {
	var subscriberID: Int?
	var subscriberDisplayID, fullName, username, emailID: String?
	var profileImage: String?
	var chatID: Int?
	var message: MessageContent?
	var unseen: String?
	
	enum CodingKeys: String, CodingKey {
		case subscriberID = "subscriber_id"
		case subscriberDisplayID = "subscriber_display_id"
		case fullName = "full_name"
		case username
		case emailID = "email_id"
		case profileImage = "profile_image"
		case chatID = "chat_id"
		case message, unseen
	}
}

// MARK: - ChatHistoryResponse
struct ChatHistoryResponse: ResponseType {
	var errors: [ActioError]?
	var msg: String?
	var status, logID: String?
	var history: [History]?
}

// MARK: - History
struct History: Codable {
	var id, fromID, toID: Int?
	var message: MessageContent?
	var status, position: Int?
	
	enum CodingKeys: String, CodingKey {
		case id
		case fromID = "from_id"
		case toID = "to_id"
		case message, status, position
	}
	
	func convertToMessageKitType() -> ChatMessage {
		let sender = Sender(senderId: String(fromID ?? 0), displayName: "")
		
		let messageKind: MessageKind
		switch message?.type {
		case "image":
			if let url = URL(string: socketUrl+"/"+(message?.imgURL ?? "")), let placeHolder = UIImage(named: "placeholder") {
				let media = ChatPhoto(url: url, image: nil, placeholderImage: placeHolder, size: CGSize(width: 300, height: 300))
				messageKind = .photo(media)
			} else {
				fallthrough
			}
			
		default:
			messageKind = .text(message?.msg ?? "")
		}
		
		return ChatMessage(sender: sender, messageId: String(id ?? 0), sentDate: message?.date?.toDate ?? Date(), kind: messageKind, message: self.message, status: self.status, position: self.position)
	}
}

// MARK: - Message
struct MessageContent: Codable {
	var msg, date, type, imgURL: String?
	var refID: String?
}

// MARK: MessageKit Subclasses
public struct Sender: SenderType {
	public let senderId: String
	public let displayName: String
}

public struct ChatMessage: MessageType {
	public var sender: SenderType
	public var messageId: String
	public var sentDate: Date
	public var kind: MessageKind
	var message: MessageContent?
	var status, position: Int?
}

public struct ChatPhoto: MediaItem {
	public var url: URL?
	public var image: UIImage?
	public var placeholderImage: UIImage
	public var size: CGSize
}
