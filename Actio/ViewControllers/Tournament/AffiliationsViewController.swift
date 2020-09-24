//
//  AffiliationsViewController.swift
//  Actio
//
//  Created by senthil on 23/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class AffiliationsViewController: UIViewController {
    @IBOutlet var affiliationsTableView: UITableView!
    var affiliations: [TournamentAffliation]?
    var tournamentId: Int?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Affiliations"

        self.affiliationsTableView.delegate = self
        self.affiliationsTableView.dataSource = self
        self.affiliationsTableView.tableFooterView = UIView()
        getAffiliationsDetails()

    }
    private func getAffiliationsDetails() {
         let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        NetworkRouter.shared.request(tournamentDetailsUrl, method: .post, parameters: ["tournamentID": tournamentId ?? 0], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: TournamentResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let result = response.value, result.status == "200" else {
                print("🥶 Error: \(String(describing: response.error))")
                return
            }
            self.affiliations = result.tournament.affliations
            self.affiliationsTableView.reloadData()
        }
    }

}
extension AffiliationsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return affiliations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliationsTableViewCell", for: indexPath) as! AffiliationsTableViewCell
        guard let tournamentaffiliations = affiliations?[indexPath.section] else {
            return UITableViewCell()
        }
        cell.affiliationsNameLabel.text = tournamentaffiliations.name
        if let imagePath = URL(string:  baseUrl + tournamentaffiliations.logo) {
            cell.affiliationsImageView.load(url: imagePath)
        }
        return cell
    }
    
}

