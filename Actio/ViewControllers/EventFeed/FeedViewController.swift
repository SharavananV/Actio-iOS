//
//  FeedViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class FeedViewController: UIViewController {

    @IBOutlet var addFeedButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var feedTableView: UITableView!
    var feedListModel : EventFeedResponse?

    var feedID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.feedTableView.tableFooterView = UIView()
        feedListApiCall()
    }
    
    @IBAction func addFeedButtonAction(_ sender: Any) {
        
    }

    func feedListApiCall() {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        NetworkRouter.shared.request(feedListUrl, method: .post, parameters: ["feed_id": feedID ?? 0], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: EventFeedResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let model = response.value else {
                print("🥶 Error on login: \(String(describing: response.error))")
                return
            }
            
            self.feedListModel = model
            self.feedTableView.reloadData()
        }
    }


}
extension FeedViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedListModel?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        
        guard let feed = self.feedListModel?.list[indexPath.row] else {
            return UITableViewCell()
        }
        
        if let imagePath = URL(string:  baseUrl + feed.profileImage) {
            cell.feedImageView.load(url: imagePath)
        }
        cell.feedDescriptionLabel.text = feed.shortDescription
        let feedDateFormatter = DateFormatter()
        feedDateFormatter.dateFormat = "MMM dd,yyyy hh:mm:ss a"
        if let createdDate = feedDateFormatter.date(from: "\(feed.createdDate) \(feed.createdTime)"), Calendar.current.isDateInToday(createdDate) {
            let timeDiff = Date().timeIntervalSince(createdDate)
            cell.feedTimeLabel.text = timeDiff.displayString + " ago"
        }
        else {
            cell.feedTimeLabel.text = feed.createdDate+" "+feed.createdTime
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let feedList = self.feedListModel?.list[indexPath.row],
            let vc = storyboard?.instantiateViewController(withIdentifier: "FeedDetailsViewController") as? FeedDetailsViewController else {
            return
        }
        vc.feedList = feedList

        self.navigationController?.pushViewController(vc, animated: false)


    }
    
    
}


