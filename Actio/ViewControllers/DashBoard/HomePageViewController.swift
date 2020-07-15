//
//  HomePageViewController.swift
//  Actio
//
//  Created by senthil on 14/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet var homeCollectionView: UICollectionView!
    var arrHomeImage =  [String]()
    var arrHomeTitle =  [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        //FIXME: - Status bar color
        
         let view: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))

         view.backgroundColor = AppColor.OrangeColor()

         self.view.addSubview(view)

        
      //  self.navigationController?.navigationBar.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        
        self.arrHomeTitle = ["Chat History","Events","Booking History"]
        self.arrHomeImage = ["Icon-Chat","Icon-Event.png","Icon-Seat.png"]
//
//        let menuButton = UIBarButtonItem(image: UIImage(named: "down"), style: .plain, target: self, action: #selector(self.clickButton))
//        self.navigationItem.leftBarButtonItem  = menuButton
    }
    
//    @objc func clickButton(){
//        delegate?.handleMenuToggle()
//           print("button click")
//    }

}
extension HomePageViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHomeTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageCollectionViewCell", for: indexPath) as! HomePageCollectionViewCell
        
        cell.homeCellLabel.text = arrHomeTitle[indexPath.row]
        cell.homeImageView.image = UIImage(named:self.arrHomeImage[indexPath.row])
        cell.homeBackgroundView.backgroundColor = AppColor.ViewBackgroundColor()
        cell.homeBackgroundView.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        cell.homeBackgroundView.layer.cornerRadius = 5.0
        cell.homeBackgroundView.clipsToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 3
        let cellHeight = collectionView.frame.size.height/3
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

