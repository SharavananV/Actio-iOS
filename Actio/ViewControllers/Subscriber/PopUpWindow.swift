//
//  PopUpWindow.swift
//  Actio
//
//  Created by senthil on 20/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import UIKit

class PopUpWindow: UIViewController {

    private let popUpWindowView = PopUpWindowView()
    
    init(title: String, text: String, buttontext: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.popupTitle.text = title
        popUpWindowView.popupText.text = text
        popUpWindowView.popupLineView.backgroundColor = UIColor.black
        popUpWindowView.popupButton.setTitle(buttontext, for: .normal)
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpWindowView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

}

private class PopUpWindowView: UIView {
    
    let popupView = UIView(frame: CGRect.zero)
    let popupLineView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    let popupText = UILabel(frame: CGRect.zero)
    let popupButton = UIButton(frame: CGRect.zero)
    let BorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: CGRect.zero)
        // Semi-transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Popup Background
        popupView.backgroundColor = .white
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.layer.cornerRadius = 5.0
        popupView.clipsToBounds = true
        
        // Popup line
        popupLineView.backgroundColor = .white
        popupLineView.layer.borderWidth = BorderWidth
        popupLineView.layer.masksToBounds = true
        popupLineView.layer.borderColor = UIColor.black.cgColor
        popupLineView.clipsToBounds = true
        
        // Popup Title
        popupTitle.textColor = AppColor.GreyColor()
        popupTitle.backgroundColor = .white
        popupTitle.layer.masksToBounds = true
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = AppFont.PoppinsRegular(size: 14)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        
        // Popup Text
        popupText.textColor = AppColor.PurpleColor()
        popupText.font = AppFont.PoppinsSemiBold(size: 18)
        popupText.numberOfLines = 0
        popupText.textAlignment = .center
        
        // Popup Button
        popupButton.setTitleColor(UIColor.black, for: .normal)
        popupButton.applyGradient(colours: [AppColor.OrangeColor(),AppColor.RedColor()])
        popupButton.titleLabel?.font = AppFont.PoppinsSemiBold(size: 16)
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(popupText)
        popupView.addSubview(popupLineView)
        popupView.addSubview(popupButton)
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
        
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 293),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // PopupTitle constraints
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: BorderWidth),
            popupTitle.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        
        // PopupText constraints
        popupText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupText.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            popupText.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 8),
            popupText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
            popupText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
            popupText.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -8)
            ])
        
        
        popupText.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   popupText.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
                   popupText.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 8),
                   popupText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
                   popupText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
                   popupText.bottomAnchor.constraint(equalTo: popupText.topAnchor, constant: -8)
                   ])
        

        
        // PopupButton constraints
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButton.heightAnchor.constraint(equalToConstant: 44),
            popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
