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

class TournamentListViewController: UIViewController,filterValueDelegate {

    @IBOutlet weak var nearMeTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteCollectionViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var nearMeLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myFavLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var nearMeTournamentListTableView: UITableView!
    @IBOutlet var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tournamentSearchBar: UISearchBar!
    var locationManager: CLLocationManager = CLLocationManager()
    var currentCoordinates : CLLocationCoordinate2D?
    var tournamentListModel : TournamentListModel?
    var searching = false
    var filteredList: [TournamentFavoritesModel]?
    var filterDetails: TournamentFilterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarHeightConstraint.constant = 0
        heightConstraints()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        tournamentSearchBar.delegate = self
        let reload = UIBarButtonItem(image: UIImage(named: "Icon material-refresh"), style: .plain, target: self, action: #selector(self.reloadTapped))
        let search = UIBarButtonItem(image: UIImage(named: "Icon map-search"), style: .plain, target: self, action: #selector(self.searchTapped))
        let filter = UIBarButtonItem(image: UIImage(named: "Icon awesome-filter"), style: .plain, target: self, action: #selector(self.filterTapped))
        navigationItem.rightBarButtonItems = [filter,search,reload]
        self.favoriteCollectionView.delegate = self
        self.favoriteCollectionView.dataSource = self
        self.nearMeTournamentListTableView.delegate = self
        self.nearMeTournamentListTableView.dataSource = self
        tournamentListApiCall()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let textfield = tournamentSearchBar.value(forKey: "searchField") as? UITextField {
            textfield.placeholder = "Type Your Search"
            textfield.font = AppFont.PoppinsRegular(size: 15)
        }

    }
    
    func heightConstraints() {
        nearMeTableViewHeightConstraint.constant = 431
        nearMeLabelHeightConstraint.constant = 40
        favoriteCollectionViewHeightConstarint.constant = 239
        myFavLabelHeightConstraint.constant = 40
        nearMeLabelHeightConstraint.constant = 40
    }
      
    @objc func reloadTapped() {
        heightConstraints()
        tournamentListApiCall()
    }
    @objc func searchTapped() {
        if searchBarHeightConstraint.constant == 0 {
            searchBarHeightConstraint.constant = 56
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else if searchBarHeightConstraint.constant == 56 {
            searchBarHeightConstraint.constant = 0
            self.tournamentSearchBar.text = ""
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            tournamentListApiCall()
            heightConstraints()

        }
    }
    
    @objc func filterTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TournamentFilterViewController") as? TournamentFilterViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func tournamentListApiCall(filterdValues:[String:Any]? = nil) {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
        
        var parameters:[String:Any] = ["latitude": "\(currentCoordinates?.latitude ?? 0)", "longitude": "\(currentCoordinates?.longitude ?? 0)","search":self.tournamentSearchBar.text ?? "" ]
        if filterdValues != nil {
            parameters["latitude"] = filterdValues?["latitude"]
            parameters["longitude"] = filterdValues?["longitude"]
            parameters["price_range_start"] = filterdValues?["price_range_start"]
            parameters["price_range_end"] = filterdValues?["price_range_end"]
            parameters["category"] = filterdValues?["category"]
            parameters["type"] = filterdValues?["type"]
            parameters["radius"] = filterdValues?["radius"]
            parameters["sport"] = filterdValues?["sport"]
            parameters["city"] = filterdValues?["city"]
        }
        ActioSpinner.shared.show(on: view)
        NetworkRouter.shared.request(tournamentListUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: TournamentListResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let model = response.value,model.status == "200" else {
                print("🥶 Error on login: \(String(describing: response.error))")
                return
            }
            self.tournamentListModel = model.list
            self.nearMeTournamentListTableView.reloadData()
            self.favoriteCollectionView.reloadData()
        }
    }
    
    func FilterdValues(parameters: [String : Any]) {
        
        if myFavLabelHeightConstraint.constant == 40 && favoriteCollectionViewHeightConstarint.constant == 239 {
            myFavLabelHeightConstraint.constant = 0
            favoriteCollectionViewHeightConstarint.constant = 0
            nearMeLabelHeightConstraint.constant = 0
            tournamentListApiCall(filterdValues: parameters)
        }
    }
    
}
extension TournamentListViewController : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tournamentListModel?.favorites?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"TournamentFavoriteCollectionViewCell", for: indexPath) as? TournamentFavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let tournament = self.tournamentListModel?.favorites?[indexPath.row] else {
            return UICollectionViewCell()
        }
    
        if let logo = tournament.tournamentLogo,let imagePath = URL(string:  baseImageUrl + logo) {
            cell.tournamentFavImageView.load(url: imagePath)
        }
                
        cell.tournamentFavSportsNameLabel.text = tournament.tournamentName
        cell.tournamentFavLocationLabel.text = tournament.venue
        cell.setDateText(tournament.tournamentStartDate ?? "", month: tournament.tournamentStartMonth ?? "", year: tournament.tournamentStartYear ?? "")
        cell.tournamentFavRegistrationStatusLabel.text = tournament.registrationStatus.displayString
        cell.tournamentFavRegistrationStatusLabel.backgroundColor = tournament.registrationStatus.backgroundColor
        cell.tournamentFavLocationImage.image = UIImage(named: "Icon-material-location-on")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 220)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let tournament = self.tournamentListModel?.favorites?[indexPath.row],
            let vc = storyboard?.instantiateViewController(withIdentifier: "TournamentDetailsViewController") as? TournamentDetailsViewController else {
            return
        }
        vc.tournamentId = tournament.id
        self.navigationController?.pushViewController(vc, animated: false)
    }

}

extension TournamentListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tournamentListModel?.nearMe?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NearMeTournamentListTableViewCell", for: indexPath) as? NearMeTournamentListTableViewCell else {
            return UITableViewCell()
        }
        
        guard let tournament = self.tournamentListModel?.nearMe?[indexPath.row] else {
            return UITableViewCell()
        }
        
        if let logo = tournament.tournamentLogo,let imagePath = URL(string:  baseImageUrl + logo) {
            cell.nearMeTournamentImage.load(url: imagePath)
        }
     
        cell.nearMeTournamentNameLabel.text = tournament.tournamentName
        cell.nearMeDateLabel.text = (tournament.tournamentStartRange ?? "") + " - " + (tournament.tournamentEndRange ?? "")
        cell.nearMeTournamentRegistrationStatusLabel.text = tournament.registrationStatus.displayString
        cell.nearMeTournamentRegistrationStatusLabel.backgroundColor = tournament.registrationStatus.backgroundColor
        cell.nearMeLocationLabel.text = tournament.tournamentVenue
        cell.nearMeCalenderImage.image = UIImage(named: "Icon-awesome-calendar-alt")
        cell.nearMeLocationImage.image = UIImage(named: "Icon-material-location-on")

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tournament = self.tournamentListModel?.nearMe?[indexPath.row],
            let vc = storyboard?.instantiateViewController(withIdentifier: "TournamentDetailsViewController") as? TournamentDetailsViewController else {
            return
        }
        
        vc.tournamentId = tournament.id
        self.navigationController?.pushViewController(vc, animated: false)
        
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

extension TournamentListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        self.nearMeTournamentListTableView.reloadData()
        self.favoriteCollectionView.reloadData()
     }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tournamentSearchBar.resignFirstResponder()
        tournamentListApiCall()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tournamentSearchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        tournamentSearchBar.resignFirstResponder()
        self.nearMeTournamentListTableView.reloadData()
        self.favoriteCollectionView.reloadData()
    }

}



