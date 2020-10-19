//
//  EventDetailViewController.swift
//  Actio
//
//  Created by senthil on 30/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

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
	@IBOutlet var registerButton: UIButton!
	
	let service = DependencyProvider.shared.networkService
	private var isDescriptionExpanded: Bool = false
	private var eventDetails: EventDetail?
	private lazy var actionDataSource = EventActionDatasource(self)
	private var galleryDatasource: TournamentGalleryDatasource?
	
	var eventId, registrationID: Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		registerForPreviewing(with: self, sourceView: galleryCollectionView)

		setupCollectionView()
		getEventDetails()
    }
	
	private func getEventDetails() {
		service.post(eventDetailUrl,
					 parameters: ["eventID": eventId ?? 0],
					 onView: self.view) { (response: EventDetailResponse) in
			UDHelper.setData(for: .currentEvent, data: response.event)
			self.eventDetails = response.event
			self.updateUI()
		}
	}
	
	func detailViewController(for index: Int) -> ImagePreviewViewController {
		guard let vc = storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController else {
			fatalError("Couldn't load detail view controller")
		}
		
		if let eventBanner = eventDetails?.eventBanner {
			let bannerUrls = eventBanner.map {
				URL(string:  baseImageUrl + $0)
			}
			
			vc.previewUrl = bannerUrls[index]
		}
		
		return vc
	}
	
	@IBAction func favoriteButtonAction(_ sender: Any) {
	}
	
	@IBAction func shareButtonAction(_ sender: Any) {
		let actionSheet = UIAlertController(title: "Share Event", message: nil, preferredStyle: .actionSheet)
		
		let internalShare = UIAlertAction(title: "Internal Share", style: .default) { [weak self] (action) in
			if let vc = UIStoryboard(name: "Social", bundle: nil).instantiateViewController(withIdentifier: "ContactsListViewController") as? ContactsListViewController {
				vc.message = "Actio Application , Let me recommend you this event \(self?.eventDetails?.eventName ?? "")"
				vc.shareType = "Event"
				vc.referenceId = String(self?.eventDetails?.id ?? 0)
				
				self?.navigationController?.pushViewController(vc, animated: true)
			}
		}
		actionSheet.addAction(internalShare)
		
		let externalShare = UIAlertAction(title: "External Share", style: .default) { (action) in
			guard let eventId = self.eventDetails?.id else {
				return
			}
			let shareLink = "Actio Application, Let me recommend you this event \n\nhttp://playactio.com/x?f=" + String(eventId) + "&screen=E"
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
			readMoreButton.setTitle("Less", for: .normal)
		}
		
		isDescriptionExpanded = !isDescriptionExpanded
	}
	
	@IBAction func openRegistrationPage(_ sender: Any) {
		service.post(eventRegistrationStatusUrl, parameters: ["eventID": String(eventId ?? 0)], onView: view) { (response: EventRegistrationStatus) in
			if let status = response.view?.status {
				switch status {
				case 1:
					if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPlayersViewController") as? AddPlayersViewController {
						vc.eventDetails = self.eventDetails
						vc.registrationId = response.view?.registrationID
						self.navigationController?.pushViewController(vc, animated: true)
					}
					
				case 2:
					if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventSummaryViewController") as? EventSummaryViewController {
						vc.eventDetails = self.eventDetails
						self.navigationController?.pushViewController(vc, animated: true)
					}
					
				default:
					self.performSegue(withIdentifier: "toRegistration", sender: sender)
				}
				
				self.registrationID = response.view?.registrationID
			}
			else {
				self.performSegue(withIdentifier: "toRegistration", sender: sender)
			}
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let eventRegistrationVC = segue.destination as? EventRegistrationViewController {
			eventRegistrationVC.eventDetails = eventDetails
			eventRegistrationVC.registrationId = registrationID
		}
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
		
		if let logo = event.eventLogo,let imagePath = URL(string:  baseImageUrl + logo) {
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
				URL(string:  baseImageUrl + $0)
			}
			
			self.galleryDatasource = TournamentGalleryDatasource(self, galleryUrls: bannerUrls)
			galleryCollectionView?.dataSource = galleryDatasource
			galleryCollectionView?.delegate = galleryDatasource
			
			galleryCollectionView?.reloadData()
		}
		
		if event.isEventOpen == 1 {
			registerButton.isHidden = false
		} else {
			registerButton.isHidden = true
		}
	}
}

extension EventDetailViewController: UIViewControllerPreviewingDelegate {
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = galleryCollectionView.indexPathForItem(at: location), let frame = galleryCollectionView.cellForItem(at: indexPath)?.frame {
			previewingContext.sourceRect = frame
			return detailViewController(for: indexPath.row)
		}
		
		return nil
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
	}
}
