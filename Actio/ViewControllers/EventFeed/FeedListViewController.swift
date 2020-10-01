//
//  FeedViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire

class FeedListViewController: UIViewController {

    @IBOutlet var addFeedButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var feedTableView: UITableView!
    var feedList: [FeedDetailModel]?
    var filteredList: [FeedDetailModel]?
    var searching = false
    var deletePlanetIndexPath: NSIndexPath? = nil
    var subscriberID :Int?
    var feedID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.searchBar.delegate = self
        self.feedTableView.tableFooterView = UIView()
        searchBar.backgroundImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.placeholder = "Search by Title or Description"
            textfield.font = AppFont.PoppinsRegular(size: 15)
        }
        
        feedListApiCall()
    }
    
    @IBAction func addFeedButtonAction(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEditFeedViewController {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    func feedListApiCall() {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
        
        ActioSpinner.shared.show(on: view)
        
        NetworkRouter.shared.request(feedListUrl, method: .post, parameters: ["feed_id": feedID ?? 0], encoding: JSONEncoding.default, headers: headers).responseDecodable(of: EventFeedResponse.self, queue: .main) { (response) in
            ActioSpinner.shared.hide()
            
            guard let model = response.value,model.status == "200" else {
                print("🥶 Error on login: \(String(describing: response.error))")
                return
            }
            self.feedList = model.list
            self.feedTableView.reloadData()
        }
    }
    


}
extension FeedListViewController : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? (self.filteredList?.count ?? 0) : (self.feedList?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell else {
            return UITableViewCell()
        }
        
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
        self.subscriberID = feed.subscriberID
        
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
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var configuration = UISwipeActionsConfiguration()
        let feed = feedList?[indexPath.row]
        if (feed?.myFeed == 1) {
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
                    guard let feedDetail = feed else { return }
                    
                    self.deleteFeed(feedDetail) { (success) in
                        if success {
                            self.feedList?.remove(at: indexPath.row)
                            self.feedTableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                        
                        complete(success)
                    }
                }
                let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let vc = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEditFeedViewController {
                        vc.feedModel = feed
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
                //  deleteAction.image = UIImage(named: "deletebin")
                deleteAction.backgroundColor = .red
                editAction.backgroundColor = .blue
                configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
                configuration.performsFirstActionWithFullSwipe = true
        }
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
        }
        shareAction.backgroundColor = .green

        configuration = UISwipeActionsConfiguration(actions: [shareAction])

        return configuration
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
    
    func deleteFeed(_ feed: FeedDetailModel, completion: @escaping (Bool)-> Void) {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-type": "multipart/form-data",
                                     "Content-Disposition" : "form-data"]
        let params = ["title" : feed.title,
                      "shortDescription" : feed.shortDescription,
                      "description" : feed.listDescription,
                      "isRemove": true,
                      "categoryID":1,
                      "feedID": feed.feedID
        ] as [String : Any]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        },to: feedUrl, usingThreshold: UInt64.init(),
        method: .post,
        headers: headers).response{ response in
            if(response.value != nil){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        
                        if let successStatus = parsedData["status"] as? String, successStatus == "200" ,let successText = parsedData["msg"] as? String{
                            self.view.makeToast(successText)
                            
                            completion(true)
                            return
                        }
                        else if let invalidText = parsedData["msg"] as? String {
                            self.view.makeToast(invalidText)
                        }
                    }
                } catch{
                    print(response.error ?? "")
                    self.view.makeToast("Please try again later")
                }
            }else{
                self.view.makeToast("Please try again later")
            }
            
            completion(false)
        }
    }
}


