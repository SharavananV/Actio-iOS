//
//  TournamentContactDetailsViewController.swift
//  Actio
//
//  Created by senthil on 17/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TournamentContactDetailsViewController: UIViewController {

    @IBOutlet var tournamentContactDetailLabel: UILabel!
    @IBOutlet var tournamentContactDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournamentContactDetailTableView.delegate = self
        self.tournamentContactDetailTableView.dataSource = self
        tournamentContactDetailTableView.tableFooterView = UIView()
    }

}
extension TournamentContactDetailsViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentContactDetailsTableViewCell", for: indexPath) as! TournamentContactDetailsTableViewCell
        cell.contactProfileImageView.image = UIImage.init(named: "contact-director-profile")
        cell.contactNameLabel.text = "Test"
        cell.contactEmailLabel.text = "Rahul@event.com, Rahulevent@event.com"
        cell.contactMobileNumLabel.text = "9876543210, 9876541230"
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.themePurple
        header.textLabel?.font = UIFont(name: "Poppins-Bold", size: 16)!

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Directors"
    }
    
}

