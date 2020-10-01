//
//  EventDetailViewController.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class EventDetailViewController: UIViewController {

	@IBOutlet weak var bannerImageView: UIImageView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var eventActionCollectionView: UICollectionView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var readMoreButton: UIButton!
	
	@IBOutlet weak var eventTypeLabel: UILabel!
	@IBOutlet weak var eventDateLabel: UILabel!
	@IBOutlet weak var eventEntryFeesLabel: UILabel!
	@IBOutlet weak var eventEBEFeesLabel: UILabel!
	@IBOutlet weak var eventEBELastDateLabel: UILabel!
	@IBOutlet weak var eventLastDateLabel: UILabel!
	
	@IBOutlet weak var galleryCollectionView: UICollectionView!
	
	private var isDescriptionExpanded: Bool = false
	private var eventDetails: EventDetail?
	private lazy var actionDataSource = EventActionDatasource(self)
	private var galleryDatasource: TournamentGalleryDatasource?
	
	var eventId: Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupCollectionView()
		getEventDetails()
    }
	
	private func getEventDetails() {
		let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"", "Content-Type": "application/json"]
		
		ActioSpinner.shared.show(on: view)
		
		NetworkRouter.shared.request(eventDetailUrl, method: .post, parameters: ["eventID": eventId ?? 0], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: EventDetailResponse.self, queue: .main) { (response) in
			ActioSpinner.shared.hide()
			
			guard let result = response.value, result.status == "200" else {
				print("🥶 Error: \(String(describing: response.error))")
				return
			}
			
			self.eventDetails = result.event
			self.updateUI()
		}
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = galleryCollectionView.indexPathForItem(at: location), let frame = galleryCollectionView.cellForItem(at: indexPath)?.frame {
			previewingContext.sourceRect = frame
			return detailViewController(for: indexPath.row)
		}
		
		return nil
	}
	
	func detailViewController(for index: Int) -> ImagePreviewViewController {
		guard let vc = storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController else {
			fatalError("Couldn't load detail view controller")
		}
		
		if let eventBanner = eventDetails?.eventBanner {
			let bannerUrls = eventBanner.map {
				URL(string:  baseUrl + $0)
			}
			
			vc.previewUrl = bannerUrls[index]
		}
		
		return vc
	}
	
	@IBAction func favoriteButtonAction(_ sender: Any) {
	}
	
	@IBAction func shareButtonAction(_ sender: Any) {
		let actionSheet = UIAlertController(title: "Share Event", message: nil, preferredStyle: .actionSheet)
		
		let internalShare = UIAlertAction(title: "Internal Share", style: .default) { (action) in
			// TODO: Open Contacts list and send a message
		}
		actionSheet.addAction(internalShare)
		
		let externalShare = UIAlertAction(title: "External Share", style: .default) { (action) in
			guard let eventId = self.eventDetails?.id else {
				return
			}
			let shareLink = "Actio Application, Let me recommend you this event \n\nhttps://actiosport.com/x?f=" + String(eventId) + "&screen=E"
			let activityController = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
			self.present(activityController, animated: true, completion: nil)
		}
		actionSheet.addAction(externalShare)
		
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(actionSheet, animated: true, completion: nil)
	}
	
	@IBAction func readMoreSelected(_ sender: Any) {
		if isDescriptionExpanded {
			descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 80)
			descriptionHeightConstraint.isActive = true
			readMoreButton.setTitle("Read more", for: .normal)
		}
		else {
			descriptionLabel.removeConstraint(descriptionHeightConstraint)
			readMoreButton.setTitle("Read less", for: .normal)
		}
		
		isDescriptionExpanded = !isDescriptionExpanded
	}
}

extension EventDetailViewController: TournamentGalleryProtocol, EventActionProtocol {
	func didSelectPhoto(_ index: Int) {
		
	}
	
	func didSelectAction(_ action: EventActionDatasource.EventAction) {
		switch action {
		case .matches:
			break
		}
	}
}

extension EventDetailViewController {
	private func setupCollectionView() {
		eventActionCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.reuseId)
		
		eventActionCollectionView.dataSource = actionDataSource
		eventActionCollectionView.delegate = actionDataSource
		
		eventActionCollectionView.reloadData()
		
		galleryCollectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
	}
	
	private func updateUI() {
		guard let event = self.eventDetails else { return }
		
		if let logo = event.eventLogo,let imagePath = URL(string:  baseUrl + logo) {
			bannerImageView.load(url: imagePath)
		}
		eventNameLabel.text = event.eventName
		descriptionLabel.text = event.eventDescription
		eventTypeLabel.text = event.type
		eventDateLabel.text = event.eventDate
		eventEntryFeesLabel.text = event.eventFee
		eventEBEFeesLabel.text = event.eventBirdFee
		eventEBELastDateLabel.text = event.eventEarlyBirdEndDate
		eventLastDateLabel.text = event.eventRegistrationEndDate
		
		let labelHeight = descriptionLabel.textHeight(withWidth: descriptionLabel.frame.width)
		if labelHeight > 80 {
			descriptionHeightConstraint.constant = 80
			readMoreButton.isHidden = false
		}
		else {
			descriptionLabel.removeConstraint(descriptionHeightConstraint)
			readMoreButton.isHidden = true
		}
		
		if let eventBanner = event.eventBanner {
			let bannerUrls = eventBanner.map {
				URL(string:  baseUrl + $0)
			}
			
			self.galleryDatasource = TournamentGalleryDatasource(self, galleryUrls: bannerUrls)
			galleryCollectionView?.dataSource = galleryDatasource
			galleryCollectionView?.delegate = galleryDatasource
			
			galleryCollectionView?.reloadData()
		}
	}
}
