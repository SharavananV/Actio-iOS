//
//  TournamentListViewController.swift
//  Actio
//
//  Created by senthil on 10/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class TournamentListViewController: UIViewController {

    @IBOutlet var nearMeTournamentListTableView: UITableView!
    @IBOutlet var favoriteCollectionView: UICollectionView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentCoordinates : CLLocationCoordinate2D?
    var tournamentListModel : TournamentListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        print((currentCoordinates?.latitude ?? 0))
        print((currentCoordinates?.longitude ?? 0))

        tournamentListApiCall()

        self.favoriteCollectionView.delegate = self
        self.favoriteCollectionView.dataSource = self
        
        self.nearMeTournamentListTableView.delegate = self
        self.nearMeTournamentListTableView.dataSource = self
    }
    
    func tournamentListApiCall() {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIxMjMiLCJpZCI6NzQwMiwiaWF0IjoxNTk5MjE2NTc2fQ.d_k_-0izxRbpKdoMkmUrrY9uhawiPCoEDQwnoiUUv4M",
                                     "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        AF.request(tournamentListUrl, method: .post, parameters: ["latitude": "\(currentCoordinates?.latitude ?? 0)", "longitude": "\(currentCoordinates?.longitude ?? 0)"], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: TournamentListResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let model = response.value else {
                print("🥶 Error on login: \(String(describing: response.error))")
                return
            }
            
            self.tournamentListModel = model.list
            self.favoriteCollectionView.reloadData()
            self.nearMeTournamentListTableView.reloadData()
        }
    }
}
extension TournamentListViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tournamentListModel?.favorites.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TournamentFavoriteCollectionViewCell", for: indexPath) as! TournamentFavoriteCollectionViewCell
        
        guard let tournament = self.tournamentListModel?.favorites[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        if let imagePath = URL(string:  baseUrl + tournament.tournamentLogo) {
            cell.tournamentFavImageView.load(url: imagePath)
        }
        
        cell.tournamentFavSportsNameLabel.text = tournament.tournamentName
        cell.tournamentFavLocationLabel.text = tournament.venue
        cell.setDateText(tournament.tournamentStartDate, month: tournament.tournamentStartMonth, year: tournament.tournamentStartYear)
        cell.tournamentFavRegistrationStatusLabel.text = tournament.registrationStatus.displayString
        cell.tournamentFavRegistrationStatusLabel.backgroundColor = tournament.registrationStatus.backgroundColor
        cell.tournamentFavLocationImage.image = UIImage(named: "Icon material-home")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 220)
    }
}

extension TournamentListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tournamentListModel?.nearMe.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearMeTournamentListTableViewCell", for: indexPath) as! NearMeTournamentListTableViewCell
        
        guard let tournament = self.tournamentListModel?.favorites[indexPath.row] else {
            return UITableViewCell()
        }
        
        if let imagePath = URL(string:  baseUrl + tournament.tournamentLogo) {
            cell.nearMeTournamentImage.load(url: imagePath)
        }
        cell.nearMeTournamentNameLabel.text = tournament.tournamentName
        cell.nearMeDateLabel.text = tournament.tournamentStartRange + " - " + tournament.tournamentEndRange
        cell.nearMeTournamentRegistrationStatusLabel.text = tournament.registrationStatus.displayString
        cell.nearMeTournamentRegistrationStatusLabel.backgroundColor = tournament.registrationStatus.backgroundColor
        cell.nearMeLocationLabel.text = tournament.venue
        cell.nearMeCalenderImage.image = UIImage(named: "Icon material-home")
        cell.nearMeLocationImage.image = UIImage(named: "Icon material-home")

        return cell
    }
    
}
extension TournamentListViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentCoordinates == nil {
            currentCoordinates = locations.last?.coordinate
        }
        currentCoordinates = locations.last?.coordinate
    }
    
}



