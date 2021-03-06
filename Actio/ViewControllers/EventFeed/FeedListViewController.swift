//
//  FeedViewController.swift
//  Actio
//
//  Created by senthil on 25/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu

class FeedListViewController: UIViewController, LogoutDelegate {

    @IBOutlet var addFeedButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var feedTableView: UITableView!
	
	private let service = DependencyProvider.shared.networkService
    var feedList: [FeedDetailModel]?
    var filteredList: [FeedDetailModel]?
    var searching = false
    var deletePlanetIndexPath: NSIndexPath? = nil
    var subscriberID :Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        self.searchBar.delegate = self
        self.feedTableView.tableFooterView = UIView()
        searchBar.backgroundImage = UIImage()
        changeNavigationBar()

		let menuButton = UIBarButtonItem(image: UIImage(named: "menu-white"), style: .plain, target: self, action: #selector(self.handleMenuToggle))
		self.navigationItem.leftBarButtonItem  = menuButton
		let notificationButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(self.openNotificationPage))
		self.navigationItem.rightBarButtonItem  = notificationButton
		
		self.title = "Actio Sport"
	}
    
    override func viewWillAppear(_ animated: Bool) {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.placeholder = "Search by Title or Description"
            textfield.font = AppFont.PoppinsRegular(size: 15)
        }
        
        feedListApiCall()
    }
	
	@objc func handleMenuToggle() {
		if let menuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
			menuController.delegate = self
			
			let menu = SideMenuNavigationController(rootViewController: menuController)
			menu.leftSide = true
			menu.menuWidth = UIScreen.main.bounds.size.width - 80
			menu.statusBarEndAlpha = 0
			menu.isNavigationBarHidden = true
			present(menu, animated: true, completion: nil)
		}
	}
	
	@objc func openNotificationPage() {
		let notificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
		let navigationController = UINavigationController(rootViewController: notificationVC)
		
		navigationController.modalPresentationStyle = .fullScreen
		present(navigationController, animated: true, completion: nil)
	}
    
    @IBAction func addFeedButtonAction(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEditFeedViewController {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    func feedListApiCall() {
		service.post(feedListUrl, parameters: nil, onView: view) { (response: EventFeedResponse) in
			guard let detail = response.list else { return }
			
			switch detail {
			case .list(let values):
				self.feedList = values
			case .detail(_):
				break
			}
			
			self.feedTableView.reloadData()
		}
    }

	func presentLogin() {
		self.dismiss(animated: true) {
			if let topController = UIApplication.shared.keyWindow()?.topViewController() {
				let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
				controller.modalPresentationStyle = .fullScreen
				topController.present(controller, animated: false, completion: nil)
			}
		}
	}
}
extension FeedListViewController : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? (self.filteredList?.count ?? 0) : (self.feedList?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedList = searching ? self.filteredList : self.feedList
        
        guard let feed = feedList?[indexPath.row] else {
            return UITableViewCell()
        }
        if feed.images != nil {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell else {
				return UITableViewCell()
			}
			
            if feed.profileImage != nil {
                if let imagePath = URL(string:  baseImageUrl + feed.profileImage!) {
                    cell.feedProfileImageView.load(url: imagePath)
                }
            }else {
                cell.feedProfileImageView.image = #imageLiteral(resourceName: "205383133115.jpg")
            }
            
            cell.feedDescriptionLabel.text = feed.listDescription
            cell.feedNameLabel.text = feed.fullName
            cell.feedTitleLabel.text = feed.title
            self.subscriberID = feed.subscriberID
            if feed.images != nil {
                if let imagePath = URL(string:  baseImageUrl + feed.images!) {
                    cell.feedImageView.load(url: imagePath)
                }
            }
            
			cell.feedTimeLabel.text = feed.createdDate
            
            return cell
            
        } else {
			guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "FeedWithoutImageTableViewCell", for: indexPath) as? FeedWithoutImageTableViewCell else {
				return UITableViewCell()
			}
			
            if feed.profileImage != nil {
                if let imagePath = URL(string:  baseImageUrl + feed.profileImage!) {
                    cell2.feedProfileImageView.load(url: imagePath)
                }
            }else {
                cell2.feedProfileImageView.image = #imageLiteral(resourceName: "205383133115.jpg")
            }
            
            cell2.feedDescriptionLabel.text = feed.listDescription
            cell2.feedNameLabel.text = feed.fullName
            cell2.feedTitleLabel.text = feed.title
            self.subscriberID = feed.subscriberID
            
			cell2.feedTimeLabel.text = feed.createdDate
            
            return cell2
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedList = searching ? self.filteredList : self.feedList
        
        guard let feedDetail = feedList?[indexPath.row],
            let vc = storyboard?.instantiateViewController(withIdentifier: "FeedDetailsViewController") as? FeedDetailsViewController else {
            return
        }
        vc.feedDetail = feedDetail

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var configuration = UISwipeActionsConfiguration()
        let feed = feedList?[indexPath.row]
        if (feed?.myFeed == 1) {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
                guard let feedDetail = feed else { return }
                
                let alert = UIAlertController(title: nil, message: "Do You want to delete this feed?", preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                })
                alert.addAction(cancel)
                                let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.deleteFeed(feedDetail) { (success) in
                        if success {
                            self.feedList?.remove(at: indexPath.row)
                            self.feedTableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                        complete(success)
                    }
                })
                alert.addAction(ok)
               
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true)
                })
                
            }
            let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as? AddEditFeedViewController {
                    vc.feedModel = feed
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
				self.shareFeed(feed)
            }
            
            shareAction.backgroundColor = .white
            editAction.backgroundColor = .white
            deleteAction.backgroundColor = .white
            
            UIImageView.appearance(
                whenContainedInInstancesOf: [UITableView.self])
                .tintColor = AppColor.OrangeColor()
            
            shareAction.image = UIImage(named: "Icon awesome-share-alt")
            deleteAction.image = UIImage(named: "Icon material-delete")
            editAction.image = UIImage(named: "Icon awesome-edit")
            
            configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction,shareAction])
            configuration.performsFirstActionWithFullSwipe = true
        }else {
            let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
            }
            shareAction.image = UIImage(named: "Icon awesome-share-alt")
            shareAction.backgroundColor = .white
            configuration = UISwipeActionsConfiguration(actions: [shareAction])
        }

        return configuration
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredList = self.feedList
        } else if let list = self.feedList {
            self.filteredList = list.filter { (model) -> Bool in
                model.title?.contains(searchText) ?? false || model.listDescription?.contains(searchText) ?? false
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
	
	func shareFeed(_ feed: FeedDetailModel?) {
		let actionSheet = UIAlertController(title: "Share Event", message: nil, preferredStyle: .actionSheet)
		
		let internalShare = UIAlertAction(title: "Internal Share", style: .default) { [weak self] (action) in
			if let vc = UIStoryboard(name: "Social", bundle: nil).instantiateViewController(withIdentifier: "ContactsListViewController") as? ContactsListViewController {
				vc.message = "Actio Application, Let me recommend you this feed post \(feed?.fullName ?? "")"
				vc.shareType = "Feed"
				vc.referenceId = String(feed?.feedID ?? 0)
				
				self?.navigationController?.pushViewController(vc, animated: true)
			}
		}
		actionSheet.addAction(internalShare)
		
		let externalShare = UIAlertAction(title: "External Share", style: .default) { (action) in
			let shareLink = "Actio Application, Let me recommend you this event \n\nhttp://playactio.com/x?f=" + String(feed?.feedID ?? 0) + "&screen=F"
			let activityController = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
			self.present(activityController, animated: true, completion: nil)
		}
		actionSheet.addAction(externalShare)
		
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(actionSheet, animated: true, completion: nil)
	}
    
    func deleteFeed(_ feed: FeedDetailModel, completion: @escaping (Bool)-> Void) {
        let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                     "Content-type": "multipart/form-data",
                                     "Content-Disposition" : "form-data"]
        let params = ["title" : feed.title ?? "",
                      "description" : feed.listDescription ?? "",
                      "isRemove": true,
                      "categoryID":1,
                      "feedID": feed.feedID ?? 0
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
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? Dictionary<String, AnyObject>
                        
                        if let successStatus = parsedData?["status"] as? String, successStatus == "200" ,let successText = parsedData?["msg"] as? String{
                            self.view.makeToast(successText)
                            
                            completion(true)
                            return
                        }
                        else if let invalidText = parsedData?["msg"] as? String {
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


