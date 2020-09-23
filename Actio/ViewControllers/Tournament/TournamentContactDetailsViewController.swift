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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournamentContactDetailTableView.delegate = self
        self.tournamentContactDetailTableView.dataSource = self
        tournamentContactDetailTableView.tableFooterView = UIView()
        
        getTournamentContactDetails()
    }
    private func getTournamentContactDetails() {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIxMjMiLCJpZCI6NzQwMiwiaWF0IjoxNTk5MjE2NTc2fQ.d_k_-0izxRbpKdoMkmUrrY9uhawiPCoEDQwnoiUUv4M",
                                     "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        NetworkRouter.shared.request(tournamentDetailsUrl, method: .post, parameters: ["tournamentID": 188], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: TournamentResponse.self, queue: .main) { (response) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentContactDetailsTableViewCell", for: indexPath) as! TournamentContactDetailsTableViewCell

        guard let tournament = self.tournamentContactDetails?.directorsOrganizers[indexPath.section].items[indexPath.row] else {
                  return UITableViewCell()
              }
        
        cell.contactProfileImageView.image = UIImage.init(named: "contact-director-profile")
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

