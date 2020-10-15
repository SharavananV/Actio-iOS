//
//  ChatViewController.swift
//  Actio
//
//  Created by senthil on 12/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

	private let service = DependencyProvider.shared.networkService
	private let socketManager = SocketIOManager()
	private var messages: [ChatMessage] = []
	var conversation: Conversation?
	var friendsModel: Friend? {
		didSet {
			self.conversation = friendsModel?.convertToConversation()
		}
	}
	private var loggedInUser: LoginModelResponse?
	private lazy var imagePicker = ActioImagePicker(presentationController: self, delegate: self)
	
    override func viewDidLoad() {
        super.viewDidLoad()

		socketManager.delegate = self
		
		self.loggedInUser = UDHelper.getData(for: .loggedInUser)
		self.title = conversation?.fullName
		
		if let fromId = loggedInUser?.subscriberSeqID, let toId = conversation?.subscriberID {
			socketManager.connectUser(fromId: String(fromId), toId: String(toId))
		}
		
		checkChatHistory()
		customiseMessageKit()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let fromId = loggedInUser?.subscriberSeqID, let toId = conversation?.subscriberID {
			socketManager.connectUser(fromId: String(fromId), toId: String(toId))
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		socketManager.closeConnection()
	}
	
	private func checkChatHistory() {
		service.post(chatHistoryUrl, parameters: ["friendID": conversation?.subscriberID ?? ""], onView: view) { (response: ChatHistoryResponse) in
			self.messages = response.history?.map({ $0.convertToMessageKitType() }) ?? []
			
			self.messagesCollectionView.reloadData()
			self.messagesCollectionView.scrollToBottom()
		}
	}
}

extension ChatViewController: SocketIODelegate {
	func receivedChat(_ chatItem: ChatItem) {
		if let toId = conversation?.subscriberID, toId != Int(loggedInUser?.subscriberID ?? "0") {
			chatItem.senderId = String(toId)
			chatItem.senderName = conversation?.fullName
			
			let chatMessage = chatItem.convertIntoMessage()
			messages.append(chatMessage)
			
			messagesCollectionView.reloadData()
			messagesCollectionView.scrollToBottom()
			
			if messageInputBar.sendButton.isAnimating {
				messageInputBar.sendButton.stopAnimating()
			}
		}
	}
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
	// MARK: MessageKit Datasource
	func currentSender() -> SenderType {
		if let fromId = loggedInUser?.subscriberSeqID, let name = loggedInUser?.fullName {
			return Sender(senderId: String(fromId), displayName: name)
		}
		
		return Sender(senderId: "any_unique_id", displayName: "Steven")
	}
	
	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	
	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}
	
	func isFromCurrentSender(message: MessageType) -> Bool {
		return message.sender.senderId == String(loggedInUser?.subscriberSeqID ?? 0)
	}
	
	// MARK: MessageKit Display
	func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
		if message.sender.senderId == String(loggedInUser?.subscriberSeqID ?? 0) {
			return .bubbleTail(.topRight, .pointedEdge)
		} else {
			return .bubbleTail(.topLeft, .pointedEdge)
		}
	}
	
	func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		let name = message.sentDate.justTime()
		return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: AppFont.PoppinsRegular(size: 10)])
	}
	
	func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 12
	}
	
	private func customiseMessageKit() {
		configureMessageInputBar()
		
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messagesCollectionView.backgroundColor = .clear
		scrollsToBottomOnKeyboardBeginsEditing = true
		maintainPositionOnKeyboardFrameChanged = true
		
		if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
			layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
			layout.textMessageSizeCalculator.incomingAvatarSize = .zero
			layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
			layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)))
		}
	}
}

// MARK: Message input bar
extension ChatViewController: InputBarAccessoryViewDelegate {
	func configureMessageInputBar() {
		messageInputBar.delegate = self
		
		messageInputBar.inputTextView.tintColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
		messageInputBar.sendButton.setTitleColor(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1), for: .normal)
		messageInputBar.sendButton.setTitleColor( #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1).withAlphaComponent(0.3), for: .highlighted)
		
		let attachButton = makeButton(named: "attach") { [weak self] in
			guard let strongSelf = self else { return }
			
			self?.imagePicker.present(from: strongSelf.view)
		}.onTextViewDidChange { (button, textView) in
			button.isEnabled = textView.text.isEmpty
		}
		messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
		messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
		messageInputBar.leftStackView.alignment = .center
		
		reloadInputViews()
	}
	
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		if let fromId = loggedInUser?.subscriberSeqID, let toId = conversation?.subscriberID, let text = messageInputBar.inputTextView.text {
			socketManager.sendTextMessage(fromId: String(fromId), toId: String(toId), message: text)
			
			messageInputBar.inputTextView.text = ""
			messageInputBar.resignFirstResponder()
			messageInputBar.sendButton.startAnimating()
		}
	}
	
	private func makeButton(named: String, completion: @escaping ()->()) -> InputBarButtonItem {
		return InputBarButtonItem()
			.configure {
				$0.spacing = .fixed(10)
				$0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
				$0.setSize(CGSize(width: 25, height: 25), animated: false)
				$0.tintColor = UIColor(white: 0.8, alpha: 1)
			}.onSelected {
				$0.tintColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
			}.onDeselected {
				$0.tintColor = UIColor(white: 0.8, alpha: 1)
			}.onTouchUpInside {_ in
				completion()
			}
	}
}

extension ChatViewController: ActioPickerDelegate {
	func didSelect(url: URL?, type: String) {
		
	}
}
