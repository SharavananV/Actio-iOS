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
    
    @IBOutlet var tournamentFavRegistrationStatusLabel: PaddingLabel!
    
    @IBOutlet var tournamentFavLocationLabel: UILabel!
    
    @IBOutlet var tournamentFavLocationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tournamentFavoriteBackgroundView.backgroundColor = AppColor.FavViewBackgroundColor()
        tournamentFavRegistrationStatusLabel.layer.cornerRadius = 12.0
        tournamentFavRegistrationStatusLabel.clipsToBounds = true
        tournamentFavRegistrationStatusLabel.insets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        tournamentFavoriteBackgroundView.layer.cornerRadius = 5.0
        tournamentFavoriteBackgroundView.clipsToBounds = true
        
        self.TournamentFavoriteHeaderView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
    }
    
    func setDateText(_ day: String, month: String, year: String) {
        let dayFont = AppFont.PoppinsSemiBold(size: 12)
        let monthFont = AppFont.PoppinsSemiBold(size: 8)
        let yearFont = AppFont.PoppinsSemiBold(size: 6)
        
        let dateString = "\(day) \(month) \(year)"
        let attributedDate = NSMutableAttributedString(string: dateString)
        attributedDate.addAttributes([.font: dayFont], range: dateString.nsRange(of: day) ?? NSRange())
        attributedDate.addAttributes([.font: monthFont], range: dateString.nsRange(of: month) ?? NSRange())
        attributedDate.addAttributes([.font: yearFont], range: dateString.nsRange(of: year) ?? NSRange())
        
        self.tournamentFavTimeLabel.attributedText = attributedDate
    }
}
