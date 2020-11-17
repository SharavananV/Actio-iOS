//
//  AffiliationsViewController.swift
//  Actio
//
//  Created by senthil on 23/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AffiliationsViewController: UIViewController {
    @IBOutlet var affiliationsTableView: UITableView!
    var affiliations: [TournamentAffliation]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Affiliations"

        self.affiliationsTableView.delegate = self
        self.affiliationsTableView.dataSource = self
        self.affiliationsTableView.tableFooterView = UIView()
    }
}

extension AffiliationsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return affiliations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliationsTableViewCell", for: indexPath) as? AffiliationsTableViewCell else {
                   return UITableViewCell()
               }

        guard let tournamentaffiliations = affiliations?[indexPath.section] else {
            return UITableViewCell()
        }
        cell.affiliationsNameLabel.text = tournamentaffiliations.name
        
        if let logo = tournamentaffiliations.logo,let imagePath = URL(string:  baseImageUrl + logo) {
            cell.affiliationsImageView.load(url: imagePath)
        }

        return cell
    }
    
}

