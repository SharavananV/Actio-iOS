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
    var allContacts: [SubscriberList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tournamentContactDetailTableView.delegate = self
        self.tournamentContactDetailTableView.dataSource = self
        tournamentContactDetailTableView.tableFooterView = UIView()
        changeNavigationBar()
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Tournament Contact Details"
    }
}

extension TournamentContactDetailsViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts?[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentContactDetailsTableViewCell", for: indexPath) as? TournamentContactDetailsTableViewCell else {
                   return UITableViewCell()
               }


        guard let tournament = self.allContacts?[indexPath.section].items?[indexPath.row] else {
                  return UITableViewCell()
              }
        
        if allContacts?[indexPath.section].name == "Director" {
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
        return allContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = UIColor.themePurple
        header?.textLabel?.font = UIFont(name: "Poppins-Bold", size: 16)!

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allContacts?[section].name ?? ""
    }
    
}

