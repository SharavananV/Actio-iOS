//
//  SocketManager.swift
//  Actio
//
//  Created by senthil on 12/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager {
	
	let manager = SocketManager(socketURL: URL(string: socketUrl)!, config: [.log(true), .compress])
	lazy var socket = manager.defaultSocket
	
	var delegate: SocketIODelegate?
	
	func establishConnection(){
		switch socket.status {
		case .connected, .connecting:
			return
		default:
			socket.connect()
		}
	}
	
	func closeConnection() {
		socket.off("receiveMessage")
		socket.off(clientEvent: .connect)
		
		socket.disconnect()
	}
	
	func connectUser(fromId: String, toId: String) {
		if shouldConnect() {
			socket.on("receiveMessage") {[weak self] data, ack in
				guard let data = data[0] as? [String: Any] else { return }
				
				let chatItem = ChatItem(data)
				self?.delegate?.receivedChat(chatItem)
			}
			
			establishConnection()
			
			socket.on(clientEvent: .connect) { [weak self] (data, ack) in
				self?.socket.emit("connectUser", ["fromID": fromId, "toID": toId])
			}
		}
		else {
			self.socket.emit("connectUser", ["fromID": fromId, "toID": toId])
		}
	}
	
	func sendTextMessage(fromId: String, toId: String, message: String) {
		if !isConnected() {
			establishConnection()
			
			socket.on(clientEvent: .connect) { [weak self] (data, ack) in
				self?.socket.emitWithAck("sendMessage", ["fromID": fromId, "toID": toId, "message": message, "type": "text"]).timingOut(after: 0, callback: { (data) in
					print(data)
				})
			}
		}
		else {
			self.socket.emitWithAck("sendMessage", ["fromID": fromId, "toID": toId, "message": message, "type": "text"]).timingOut(after: 0, callback: { (data) in
				print(data)
			})
		}
	}
	
	func sendImage(fromId: String, toId: String, message: String?, imageUrl: String) {
		if !isConnected() {
			establishConnection()
			
			socket.on(clientEvent: .connect) { [weak self] (data, ack) in
				self?.socket.emitWithAck("sendMessage", ["fromID": fromId, "toID": toId, "message": message ?? "", "imageURL": imageUrl, "type": "image"]).timingOut(after: 0, callback: { (data) in
					print(data)
				})
			}
		}
		else {
			self.socket.emitWithAck("sendMessage", ["fromID": fromId, "toID": toId, "message": message ?? "", "imageURL": imageUrl, "type": "image"]).timingOut(after: 0, callback: { (data) in
				print(data)
			})
		}
	}
	
	func isConnected() -> Bool {
		return socket.status == .connected
	}
	
	func shouldConnect() -> Bool {
		return !(socket.status == .connecting || socket.status == .connected)
	}
	
	deinit {
		socket.disconnect()
	}
}

protocol SocketIODelegate {
	func receivedChat(_ chatItem: ChatItem)
}
