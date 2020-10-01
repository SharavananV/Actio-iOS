//
//  TournamentContactDetailsViewController.swift
//  Actio
//
//  Created by senthil on 17/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire


class TournamentContactDetailsViewController: UIViewController {

    @IBOutlet var tournamentContactDetailLabel: UILabel!
    @IBOutlet var tournamentContactDetailTableView: UITableView!
    private var tournamentContactDetails: Tournament?
    var tournamentId: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournamentContactDetailTableView.delegate = self
        self.tournamentContactDetailTableView.dataSource = self
        tournamentContactDetailTableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Tournament Contact Details"
        getTournamentContactDetails()

       
    }
    private func getTournamentContactDetails() {
         let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        NetworkRouter.shared.request(tournamentDetailsUrl, method: .post, parameters: ["tournamentID": tournamentId ?? 0], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: TournamentResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let result = response.value, result.status == "200" else {
                print("🥶 Error: \(String(describing: response.error))")
                return
            }
            
            self.tournamentContactDetails = result.tournament
            self.tournamentContactDetailTableView.reloadData()
        }
    }


}
extension TournamentContactDetailsViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournamentContactDetails?.directorsOrganizers[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentContactDetailsTableViewCell", for: indexPath) as? TournamentContactDetailsTableViewCell else {
                   return UITableViewCell()
               }


        guard let tournament = self.tournamentContactDetails?.directorsOrganizers[indexPath.section].items[indexPath.row] else {
                  return UITableViewCell()
              }
        
        if tournamentContactDetails?.directorsOrganizers[indexPath.section].name == "Director" {
            cell.contactProfileImageView.image = UIImage.init(named: "contact-director-profile")
        } else {
            cell.contactProfileImageView.image = UIImage.init(named: "contact-organizer-profile")

        }
        
        cell.contactNameLabel.text = tournament.username
        cell.contactEmailLabel.text = tournament.emailID
        cell.contactMobileNumLabel.text = tournament.mobileNumber
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tournamentContactDetails?.directorsOrganizers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.themePurple
        header.textLabel?.font = UIFont(name: "Poppins-Bold", size: 16)!

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tournamentContactDetails?.directorsOrganizers[section].name ?? ""
    }
    
}

