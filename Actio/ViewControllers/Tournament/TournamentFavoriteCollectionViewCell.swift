//
//  TournamentFavoriteCollectionViewswift
//  Actio
//
//  Created by senthil on 10/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TournamentFavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var tournamentFavoriteBackgroundView: UIView!
    
    @IBOutlet var TournamentFavoriteHeaderView: UIView!
    
    @IBOutlet var tournamentFavTimeLabel: UILabel!
    
    @IBOutlet var tournamentFavButton: UIButton!
    
    @IBOutlet var tournamentFavImageView: UIImageView!
    
    @IBOutlet var tournamentFavSportsNameLabel: UILabel!
    
    @IBOutlet var tournamentFavRegistrationStatusLabel: UILabel!
    
    @IBOutlet var tournamentFavLocationLabel: UILabel!
    
    @IBOutlet var tournamentFavLocationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tournamentFavoriteBackgroundView.backgroundColor = AppColor.FavViewBackgroundColor()
        tournamentFavRegistrationStatusLabel.layer.cornerRadius = 10.0
        tournamentFavRegistrationStatusLabel.clipsToBounds = true
        tournamentFavoriteBackgroundView.layer.cornerRadius = 5.0
        tournamentFavoriteBackgroundView.clipsToBounds = true
    }
}
