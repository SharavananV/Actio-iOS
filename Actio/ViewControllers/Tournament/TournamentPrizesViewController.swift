//
//  TournamentPrizesViewController.swift
//  Actio
//
//  Created by senthil on 18/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TournamentPrizesViewController: UIViewController {

    @IBOutlet var tournamentPrizeCollectionView: UICollectionView!
    @IBOutlet var tournamentSportPrizeLabel: UILabel!
    @IBOutlet var tournamentPrizesTableView: UITableView!
    var prizeCategoryLabel = [String]()
    var prizeValueLabel = [String]()
    
    private var affliationsDatasource: TournamentSponserDatasource?
    var affiliations: [TournamentAffliation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prizeCategoryLabel = ["Winner Prize","Runner Prize","Man of the Tournament","Man of the match"]
        self.prizeValueLabel = ["Rs.10000/- + Trophy","Rs.8000/- + Trophy","Rs.2000/- + Trophy","Medal"]
        self.navigationItem.title = "Tournament Prizes"

        changeNavigationBar()

        if let affiliations = self.affiliations {
            tournamentPrizeCollectionView.register(ImageTextCollectionViewCell.self, forCellWithReuseIdentifier: ImageTextCollectionViewCell.reuseId)
            
            tournamentPrizeCollectionView.layer.shadowColor = UIColor.black.cgColor
            tournamentPrizeCollectionView.layer.shadowOpacity = 1
            tournamentPrizeCollectionView.layer.shadowOffset = .zero
            tournamentPrizeCollectionView.layer.shadowPath = UIBezierPath(rect: tournamentPrizeCollectionView.bounds).cgPath
            
            self.affliationsDatasource = TournamentSponserDatasource(self, affliations: affiliations)
            tournamentPrizeCollectionView?.dataSource = affliationsDatasource
            tournamentPrizeCollectionView?.delegate = affliationsDatasource
            
            tournamentPrizeCollectionView.reloadData()
        }
        
        tournamentPrizesTableView.delegate = self
        tournamentPrizesTableView.dataSource = self
        tournamentPrizesTableView.tableFooterView = UIView()
    }
}

extension TournamentPrizesViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentPrizesTableViewCell", for: indexPath) as? TournamentPrizesTableViewCell else {
            return UITableViewCell()
        }

        cell.prizeCategoryLabel.text = prizeCategoryLabel[indexPath.row]
        cell.prizeValueLabel.text = prizeValueLabel[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = UIColor.themePurple
        header?.textLabel?.font = UIFont(name: "Poppins-Bold", size: 16)!

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Under 18 Boys Cricket"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}
