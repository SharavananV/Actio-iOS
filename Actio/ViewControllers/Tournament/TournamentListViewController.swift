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

    
    var urlString = String()
    var tournamentFavorites = NSDictionary()
    var TournamentListModel : TournamentListModel!


    var latSend : String?
    var lonSend : String?
    
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
        urlString = tournamentListUrl
        
       // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIxMjMiLCJpZCI6NzQwMiwiaWF0IjoxNTk5MjE2NTc2fQ.d_k_-0izxRbpKdoMkmUrrY9uhawiPCoEDQwnoiUUv4M"+"",

        let headers : HTTPHeaders = ["Authorization" : "Bearer "+"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIxMjMiLCJpZCI6NzQwMiwiaWF0IjoxNTk5MjE2NTc2fQ.d_k_-0izxRbpKdoMkmUrrY9uhawiPCoEDQwnoiUUv4M"+"",
            //"Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-Type": "application/json"]
        
        AF.request(urlString,method: .post, parameters: ["latitude":"\(currentCoordinates?.latitude ?? 0)", "longitude":"\(currentCoordinates?.longitude ?? 0)"], encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
           switch response.result {
            case .success (let data):
                print(data)
                if let resultDict = data as? [String: Any], let successText = resultDict["status"] as? String, successText == "200" {
                    self.tournamentFavorites = resultDict["list"] as! NSDictionary
                    self.favoriteCollectionView.reloadData()
                }
                else if let resultDict = data as? [String: Any], let invalidText = resultDict["msg"] as? String{
                    self.view.makeToast(invalidText)
                }
                else {
                    print(data)

                }

            case .failure(let error):
                print(error)
                self.view.makeToast(error.errorDescription ?? "")
            }

        }

    }
    
}
extension TournamentListViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TournamentFavoriteCollectionViewCell", for: indexPath) as! TournamentFavoriteCollectionViewCell
        
        cell.tournamentFavoriteBackgroundView.backgroundColor = AppColor.FavViewBackgroundColor()
        cell.tournamentFavRegistrationStatusLabel.layer.cornerRadius = 10.0
        cell.tournamentFavRegistrationStatusLabel.clipsToBounds = true
        cell.tournamentFavoriteBackgroundView.layer.cornerRadius = 5.0
        cell.tournamentFavoriteBackgroundView.clipsToBounds = true
        
        cell.tournamentFavTimeLabel.text = "28 July 2020"
        cell.tournamentFavImageView.image = UIImage(named: "205383133115")
        cell.tournamentFavSportsNameLabel.text = "International Football"
        cell.tournamentFavRegistrationStatusLabel.text = "Registration open"
        cell.tournamentFavLocationImage.image = UIImage(named: "Icon material-home")
        cell.tournamentFavLocationLabel.text = "Barabati Stadium, Cuttack"
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension TournamentListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearMeTournamentListTableViewCell", for: indexPath) as! NearMeTournamentListTableViewCell
        cell.nearMeTournamentImage.image = UIImage(named: "205383133115")
        cell.nearMeTournamentRegistrationStatusLabel.text = "Registration open"
        cell.nearMeTournamentNameLabel.text = "Cricket Tournament"
        cell.nearMeCalenderImage.image = UIImage(named: "Icon material-home")
        cell.nearMeDateLabel.text = "FRI JUL 20 - SUN JUL 22 2020"
        cell.nearMeLocationImage.image = UIImage(named: "Icon material-home")
        cell.nearMeLocationLabel.text = "University Platinum Jubilee Cricket Stadium, Mysore"

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



