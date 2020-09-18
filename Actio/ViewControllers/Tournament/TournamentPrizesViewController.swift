//
//  TournamentPrizesViewController.swift
//  Actio
//
//  Created by senthil on 18/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class TournamentPrizesViewController: UIViewController {

    @IBOutlet var tournamentSportPrizeLabel: UILabel!
    @IBOutlet var tournamentPrizesTableView: UITableView!
    var prizeCategoryLabel = [String]()
    var prizeValueLabel = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prizeCategoryLabel = ["Winner Prize","Runner Prize","Man of the Tournament","Man of the match"]
        self.prizeValueLabel = ["Rs.10000/- + Trophy","Rs.8000/- + Trophy","Rs.2000/- + Trophy","Medal"]
        
        tournamentPrizesTableView.delegate = self
        tournamentPrizesTableView.dataSource = self

    }

}
extension TournamentPrizesViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TournamentPrizesTableViewCell", for: indexPath) as! TournamentPrizesTableViewCell
        cell.prizeCategoryLabel.text = prizeCategoryLabel[indexPath.row]
        cell.prizeValueLabel.text = prizeValueLabel[indexPath.row]
        return cell
    }
    
    
}
