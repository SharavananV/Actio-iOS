//
//  ChatViewController.swift
//  Actio
//
//  Created by senthil on 12/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

	let socketManager = SocketIOManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		socketManager.delegate = self
		//socketManager.connectUser(fromId: "7165", toId: "72252")
		socketManager.connectUser(fromId: "72252", toId: "7165")
    }
	
	@IBAction func sendMessage(_ sender: Any) {
		socketManager.sendTextMessage(fromId: "72252", toId: "7165", message: "Hello world!")
	}
}

extension ChatViewController: SocketIODelegate {
	func receivedChat(_ chatItem: ChatItem) {
		print("Received chat from \(chatItem.message)")
	}
}
