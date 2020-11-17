//
//  EventsAssociatedCollectionViewCell.swift
//  Actio
//
//  Created by apple on 19/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class EventsAssociatedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var associatedFavButton: UIButton!
    @IBOutlet weak var associatedTimeLabel: UILabel!
    @IBOutlet weak var eventsAsscociatedBackgroundView: UIView!
    @IBOutlet weak var eventsAssociatedHeaderView: UIView!
    @IBOutlet weak var associatedImageView: UIImageView!
    @IBOutlet weak var associatedEventsName: UILabel!
    @IBOutlet weak var associatedLocationImageView: UIImageView!
    @IBOutlet weak var associatedLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventsAsscociatedBackgroundView.backgroundColor = AppColor.FavViewBackgroundColor()
        eventsAsscociatedBackgroundView.layer.cornerRadius = 5.0
        eventsAsscociatedBackgroundView.clipsToBounds = true
        
        self.eventsAssociatedHeaderView.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
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
        
        self.associatedTimeLabel.attributedText = attributedDate
    }

}
