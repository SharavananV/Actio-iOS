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
import Alamofire

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
		guard let message = chatItem.message, message.isEmpty == false else { return }
		
		let chatMessage = chatItem.convertIntoMessage()
		messages.append(chatMessage)
		
		messagesCollectionView.reloadData()
		messagesCollectionView.scrollToBottom()
		
		if messageInputBar.sendButton.isAnimating {
			messageInputBar.sendButton.stopAnimating()
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
	
	func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
		if case MessageKind.photo(let media) = message.kind, let imageURL = media.url {
			imageView.load(url: imageURL)
		}
	}
	
	func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		let name = message.sentDate.justTime() + " "
		var imageName = "sending"
		
		let fullString = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: AppFont.PoppinsRegular(size: 10)])
		
		if message.sender.senderId == String(loggedInUser?.subscriberSeqID ?? 0) {
			if let obj = message as? ChatMessage, obj.position == 1 {
				if obj.status == 1 {
					imageName = "sent"
				} else {
					imageName = "read"
				}
			}
			
			let image1Attachment = ChatTextAttachment()
			image1Attachment.image = UIImage(named: imageName)			
			let imageString = NSAttributedString(attachment: image1Attachment)
			fullString.append(imageString)
		}
		
		return fullString
	}
	
	func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 12
	}
	
	private func customiseMessageKit() {
		configureMessageInputBar()
		
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messagesCollectionView.messageCellDelegate = self
		messagesCollectionView.backgroundColor = .clear
		scrollsToBottomOnKeyboardBeginsEditing = true
		maintainPositionOnKeyboardFrameChanged = true
		
		if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
			layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
			layout.textMessageSizeCalculator.incomingAvatarSize = .zero
			layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
			layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
			layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)))
			layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)))
		}
	}
}

// MARK: Message Cell Delegate
extension ChatViewController: MessageCellDelegate {
	func didTapMessage(in cell: MessageCollectionViewCell) {
		guard let indexPath = messagesCollectionView.indexPath(for: cell),
			  let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) as? ChatMessage else {
			print("Failed to identify message when audio cell receive tap gesture")
			return
		}
		
		let refId = message.message?.refID
		switch message.message?.type {
		case "Feed":
			guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedDetailsViewController") as? FeedDetailsViewController else {
				return
			}
			vc.feedId = Int(refId ?? "0")
			self.navigationController?.pushViewController(vc, animated: false)
			
		case "Event":
			guard let vc = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController else {
				return
			}
			vc.eventId = Int(refId ?? "0")
			self.navigationController?.pushViewController(vc, animated: true)
			
		case "Tournament":
			guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TournamentDetailsViewController") as? TournamentDetailsViewController else {
				return
			}
			vc.tournamentId = Int(refId ?? "0")
			self.navigationController?.pushViewController(vc, animated: false)
			
		default:
			break
		}
	}
	
	func didTapImage(in cell: MessageCollectionViewCell) {
		guard let indexPath = messagesCollectionView.indexPath(for: cell),
			  let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) as? ChatMessage else {
			print("Failed to identify message when audio cell receive tap gesture")
			return
		}
		
		switch message.kind {
		case .photo(let media):
			let vc = ImageZoomViewController()
			vc.imageUrl = media.url
			self.navigationController?.pushViewController(vc, animated: false)
			
		default:
			break
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
		uploadChatImage(imageUrl: url)
	}
	
	func didCaptureImage(_ image: UIImage) {
		uploadChatImage(image: image)
	}
	
	// TODO: Move this call to the network router class
	func uploadChatImage(image: UIImage? = nil, imageUrl: URL? = nil) {
		messageInputBar.sendButton.startAnimating()
		
		let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
									 "Content-type": "multipart/form-data",
									 "Content-Disposition" : "form-data"]
		
		AF.upload(multipartFormData: { (multipartFormData) in
			if let imgData = image?.jpegData(compressionQuality: 1) {
				multipartFormData.append(imgData, withName: "image", fileName: "images.jpg", mimeType: "image/jpeg")
			}
			else if let imageUrl = imageUrl {
				do {
					let mediaData = try Data(contentsOf: imageUrl)
					
					multipartFormData.append(mediaData, withName: "image", fileName: imageUrl.lastPathComponent, mimeType: "image/*")
				}
				catch {
					print("Error when converting media to data")
				}
			}
			
		},to: chatUploadUrl, usingThreshold: UInt64.init(),
		method: .post,
		headers: headers).response{ [weak self] response in
			self?.messageInputBar.sendButton.stopAnimating()
			
			if(response.value != nil){
				do{
					if let jsonData = response.data{
						let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? Dictionary<String, AnyObject>
						
						if let successStatus = parsedData?["status"] as? String, successStatus == "200" {
							if let fromId = self?.loggedInUser?.subscriberSeqID, let toId = self?.conversation?.subscriberID {
								let imageURL: String = parsedData?["path"] as? String ?? ""
								let message: String = parsedData?["message"] as? String ?? ""
								
								self?.socketManager.sendImage(fromId: String(fromId), toId: String(toId), message: message, imageUrl: imageURL)
							}
						}
						else if let json = parsedData, json["status"] as? String == "422", let errors = json["errors"] as? [[String: Any]], let message = errors.first?["msg"] as? String {
							self?.view.makeToast(message)
							
							return
						}
					}
				}catch{
					print(response.error ?? "")
					self?.view.makeToast("Please try again later")
				}
			}else{
				self?.view.makeToast("Please try again later")
			}
		}
	}
}
