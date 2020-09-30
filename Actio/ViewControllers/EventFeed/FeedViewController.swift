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
    var feedList: [FeedDetailModel]?
    var filteredList: [FeedDetailModel]?
    var searching = false

    var feedID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.searchBar.delegate = self
        self.feedTableView.tableFooterView = UIView()
        feedListApiCall()
        searchBar.backgroundImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.placeholder = "Search by Title or Description"
            textfield.font = AppFont.PoppinsRegular(size: 15)
        }
    }
    
    @IBAction func addFeedButtonAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        self.navigationController?.pushViewController(vc, animated: false)
        
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
            self.feedList = model.list
            self.feedTableView.reloadData()
        }
    }


}
extension FeedViewController : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? (self.filteredList?.count ?? 0) : (self.feedList?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        
        let feedList = searching ? self.filteredList : self.feedList
        
        guard let feed = feedList?[indexPath.row] else {
            return UITableViewCell()
        }
        if feed.profileImage != nil {
            if let imagePath = URL(string:  baseUrl + feed.profileImage!) {
                cell.feedImageView.load(url: imagePath)
            }
        }
        cell.feedDescriptionLabel.text = feed.shortDescription
        
        let feedDateFormatter = DateFormatter()
        feedDateFormatter.dateFormat = "MMM dd,yyyy hh:mm:ss a"
        if let createdDate = feedDateFormatter.date(from: "\(feed.createdDate) \(feed.createdTime)"), Calendar.current.isDateInToday(createdDate) {
            let timeDiff = createdDate.timeIntervalSince(Date())
            cell.feedTimeLabel.text = timeDiff.displayString + " ago"
        }
        else {
            cell.feedTimeLabel.text = feed.createdDate+" "+feed.createdTime
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedList = searching ? self.filteredList : self.feedList
        
        guard let feedDetail = feedList?[indexPath.row],
            let vc = storyboard?.instantiateViewController(withIdentifier: "FeedDetailsViewController") as? FeedDetailsViewController else {
            return
        }
        vc.feedDetail = feedDetail

        self.navigationController?.pushViewController(vc, animated: false)


    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredList = self.feedList
        } else if let list = self.feedList {
            self.filteredList = list.filter { (model) -> Bool in
                model.title.contains(searchText) || model.shortDescription.contains(searchText)
            }
        }
        searching = true
        feedTableView.reloadData()
     }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.feedTableView.reloadData()
    }
    
}


