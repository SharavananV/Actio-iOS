//
//  FeedViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.feedTableView.tableFooterView = UIView()
    }

}
extension FeedViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        return cell
    }
    
    
}
