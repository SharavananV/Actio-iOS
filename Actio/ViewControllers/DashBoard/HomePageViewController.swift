//
//  HomePageViewController.swift
//  Actio
//
//  Created by senthil on 14/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class HomePageViewController: UIViewController, LogoutDelegate {
    
    @IBOutlet var homeCollectionView: UICollectionView!
    
    var dashboardModules: [[String: Any]] = [[String: Any]]()
    var urlString = String()
    var imagePath: URL!
    var iconPath: URL!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardApiCall()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu-white"), style: .plain, target: self, action: #selector(self.handleMenuToggle))
        self.navigationItem.leftBarButtonItem  = menuButton
        
        changeNavigationBar()
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
    
    func presentLogin() {
        self.dismiss(animated: true) {
            if let topController = UIApplication.shared.keyWindow()?.topViewController() {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
                controller.modalPresentationStyle = .fullScreen
                topController.present(controller, animated: false, completion: nil)
            }
        }
    }
    
    
    func dashboardApiCall() {
        urlString = dashboardUrl
       let headers : HTTPHeaders = ["Authorization" : "Bearer "+UDHelper.getAuthToken()+"",
                                            "Content-Type": "application/json"]
      
        
        NetworkRouter.shared.request(dashboardUrl, method: .post, parameters: nil, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success (let data):
                if let resultDict = data as? [String: Any], let successText = resultDict["status"] as? String, successText == "200" {
                    self.dashboardModules = resultDict["modules"] as! [[String : Any]]
                    self.homeCollectionView.reloadData()
                }
                else if let resultDict = data as? [String: Any], let invalidText = resultDict["msg"] as? String{
                    self.view.makeToast(invalidText)
                }
                else {
                }

            case .failure(let error):
                print(error)
                self.view.makeToast(error.errorDescription ?? "")
            }

        }

    }
        
    
   
}

extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashboardModules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HomePageCollectionViewCell", for: indexPath) as? HomePageCollectionViewCell else {
            return UICollectionViewCell()
        }

        
        cell.homeBackgroundImageView.layer.cornerRadius = 5.0
        cell.homeBackgroundImageView.clipsToBounds = true
        
        if dashboardModules.count > 0 {
            let eachCellList = dashboardModules[indexPath.row]
            cell.homeCellLabel.text = (eachCellList["name"] as? String) ?? ""
            
            if let imageUrl = eachCellList["image"] as? String {
                self.imagePath = URL(string:  baseUrl + imageUrl)
                cell.homeBackgroundImageView.load(url: self.imagePath)
            }
            
            if let iconUrl = eachCellList["icon"] as? String {
                self.iconPath = URL(string:  baseUrl + iconUrl)
                cell.homeCellImage.load(url: self.iconPath)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width / 2) - 5), height: CGFloat(170))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let nav = storyboard?.instantiateViewController(withIdentifier: "TournamentListViewController") as? TournamentListViewController {
                self.navigationController?.pushViewController(nav, animated: false)
            }
        }
    }
}
extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.16, offSet: CGSize, radius: CGFloat = 10.0, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


