//
//  TournamentDetailsViewController.swift
//  Actio
//
//  Created by apple on 16/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class TournamentDetailsViewController: UIViewController {

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
        
        setupCollectionView()
        getTournamentDetails()
    }
    
    private func getTournamentDetails() {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIxMjMiLCJpZCI6NzQwMiwiaWF0IjoxNTk5MjE2NTc2fQ.d_k_-0izxRbpKdoMkmUrrY9uhawiPCoEDQwnoiUUv4M",
                                     "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        NetworkRouter.shared.request(tournamentDetailsUrl, method: .post, parameters: ["tournamentID": 166], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: TournamentResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let result = response.value, result.status == "200" else {
                print("🥶 Error: \(String(describing: response.error))")
                return
            }
            
            self.tournamentDetails = result.tournament
            self.updateUI()
        }
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
            break
        case .eventCategory:
            break
        case .prize:
            break
        case .location:
            break
        case .affillations:
            break
        }
    }
    
    func didSelectPhoto(_ index: Int) {
        
    }
}
