//
//  TournamentDetailsViewController.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class TournamentDetailsViewController: UIViewController, UIViewControllerPreviewingDelegate {

    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var tournamentNameLabel: UILabel!
    @IBOutlet weak var tournamentActionCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var readMoreButton: UIButton!
    
    @IBOutlet weak var tournamentTypeLabel: UILabel!
    @IBOutlet weak var tournamentDateLabel: UILabel!
    @IBOutlet weak var tournamentEntryFeesLabel: UILabel!
    @IBOutlet weak var tournamentEBEFeesLabel: UILabel!
    @IBOutlet weak var tournamentEBELastDateLabel: UILabel!
    @IBOutlet weak var tournamentLastDateLabel: UILabel!
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var affliationsCollectionView: UICollectionView!
    
    private var isDescriptionExpanded: Bool = false
    private var tournamentDetails: Tournament?
    private lazy var actionDataSource = TournamentActionDatasource(self)
    private var galleryDatasource: TournamentGalleryDatasource?
    private var affliationsDatasource: TournamentSponserDatasource?
    
    var tournamentId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: galleryCollectionView)

        setupCollectionView()
        getTournamentDetails()
    }
    
    private func getTournamentDetails() {
         let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        NetworkRouter.shared.request(tournamentDetailsUrl, method: .post, parameters: ["tournamentID": tournamentId ?? 0], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: TournamentResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let result = response.value, result.status == "200" else {
                print("🥶 Error: \(String(describing: response.error))")
                return
            }
            
            self.tournamentDetails = result.tournament
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
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
            //navigationController?.pushViewController(viewControllerToCommit, animated: true)

    }
    func detailViewController(for index: Int) -> ImagePreviewViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController else {
            fatalError("Couldn't load detail view controller")
        }

        let bannerUrls = self.tournamentDetails?.tournamentBanner.map {
            URL(string:  baseUrl + $0)
        }
        
        vc.previewUrl = bannerUrls?[index]
        return vc
    }

    @IBAction func favoriteButtonAction(_ sender: Any) {
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
    }
    @IBAction func readMoreSelected(_ sender: Any) {
        if isDescriptionExpanded {
            descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 80)
            descriptionHeightConstraint.isActive = true
        }
        else {
            descriptionLabel.removeConstraint(descriptionHeightConstraint)
        }
        
        isDescriptionExpanded = !isDescriptionExpanded
    }
    
    @IBAction func seeMoreRatingsTapped(_ sender: Any) {
        
    }
}

// MARK: Update UI
extension TournamentDetailsViewController: TournamentActionProtocol, TournamentGalleryProtocol {
    private func updateUI() {
        guard let tournament = self.tournamentDetails else { return }
        
        if let imagePath = URL(string:  baseUrl + tournament.tournamentLogo) {
            bannerImageView.load(url: imagePath)
        }
        tournamentNameLabel.text = tournament.tournamentName
        descriptionLabel.text = tournament.tournamentDescription
        tournamentTypeLabel.text = tournament.feeType
        tournamentDateLabel.text = tournament.tournamentDate
        tournamentEntryFeesLabel.text = tournament.entryFees
        tournamentEBEFeesLabel.text = tournament.earlyBirdEntryFees
        tournamentEBELastDateLabel.text = tournament.eBEDateRange
        tournamentLastDateLabel.text = tournament.registrationEndDateRange
        
        let labelHeight = descriptionLabel.textHeight(withWidth: descriptionLabel.frame.width)
        if labelHeight > 80 {
            descriptionHeightConstraint.constant = 80
            readMoreButton.isHidden = false
        }
        else {
            descriptionLabel.removeConstraint(descriptionHeightConstraint)
            readMoreButton.isHidden = true
        }
        
        let bannerUrls = tournament.tournamentBanner.map {
            URL(string:  baseUrl + $0)
        }
        self.galleryDatasource = TournamentGalleryDatasource(self, galleryUrls: bannerUrls)
        galleryCollectionView?.dataSource = galleryDatasource
        galleryCollectionView?.delegate = galleryDatasource
        
        galleryCollectionView?.reloadData()
        
        self.affliationsDatasource = TournamentSponserDatasource(self, affliations: tournament.affliations)
        affliationsCollectionView?.dataSource = affliationsDatasource
        affliationsCollectionView?.delegate = affliationsDatasource
        
        affliationsCollectionView?.reloadData()
    }
    
    private func setupCollectionView() {
        tournamentActionCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.reuseId)
        
        tournamentActionCollectionView.dataSource = actionDataSource
        tournamentActionCollectionView.delegate = actionDataSource
        
        tournamentActionCollectionView.reloadData()
        
        galleryCollectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        
        affliationsCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.reuseId)
        
        affliationsCollectionView.layer.shadowColor = UIColor.black.cgColor
        affliationsCollectionView.layer.shadowOpacity = 1
        affliationsCollectionView.layer.shadowOffset = .zero
        affliationsCollectionView.layer.shadowPath = UIBezierPath(rect: affliationsCollectionView.bounds).cgPath
    }
    
    func didSelectAction(_ action: TournamentActionDatasource.TournamentAction) {
        switch action {
        case .organiser:
            if let organiserVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TournamentContactDetailsViewController") as? TournamentContactDetailsViewController {
                organiserVc.tournamentId = tournamentDetails?.id
                self.navigationController?.pushViewController(organiserVc, animated: true)
            }
        case .eventCategory:
            break
        case .prize:
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TournamentPrizesViewController") as? TournamentPrizesViewController {
                vc.affiliations = tournamentDetails?.affliations
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .location:
            if let locationVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TournamentLocationViewController") as? TournamentLocationViewController {
                locationVc.tournamentLocation = tournamentDetails
                self.navigationController?.pushViewController(locationVc, animated: true)
            }
        case .affillations:
            if let affiliationsVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AffiliationsViewController") as? AffiliationsViewController {
                affiliationsVc.tournamentId = tournamentDetails?.id
                affiliationsVc.affiliations = tournamentDetails?.affliations
                self.navigationController?.pushViewController(affiliationsVc, animated: true)
            }
        }
    }
    
    func didSelectPhoto(_ index: Int) {
        
    }
}
