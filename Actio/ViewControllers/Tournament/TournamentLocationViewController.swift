//
//  TournamentLocationViewController.swift
//  Actio
//
//  Created by senthil on 23/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class TournamentLocationViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var locationMapview: MKMapView!
    @IBOutlet var locationBackgroundView: UIView!
    @IBOutlet var locationImageView: UIImageView!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationAddressLabel: UILabel!
    var tournamentLocation: Tournament?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Map Directions"

        
        locationBackgroundView.layer.cornerRadius = 10
        locationBackgroundView.layer.masksToBounds = true

        locationBackgroundView.backgroundColor = UIColor.white
        locationBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        locationBackgroundView.layer.shadowOpacity = 0.8
        locationBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        locationBackgroundView.layer.shadowRadius = 6.0
        locationBackgroundView.layer.masksToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tournamentDetails = self.tournamentLocation {
            self.locationNameLabel.text = tournamentDetails.tournamentVenue
            self.locationAddressLabel.text = tournamentDetails.tournamentAddress
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: tournamentDetails.tournamentLat ?? 0.0, longitude: tournamentDetails.tournamentLong ?? 0.0)
            
            let region = MKCoordinateRegion( center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
            self.locationMapview.setRegion(locationMapview.regionThatFits(region), animated: true)
            self.locationMapview.addAnnotation(annotation)
        }
        else {
            fatalError("Always initialise tournament")
        }
    }
}
