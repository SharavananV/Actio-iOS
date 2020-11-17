//
//  ShowKPIReasonViewController.swift
//  Actio
//
//  Created by KnilaDev on 12/11/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol SendReasonProtocol: class {
	func sendReason(_ message: String?)
}

class ShowKPIReasonViewController: UIViewController {

	@IBOutlet var reasonTextView: UITextView!
	@IBOutlet var shadowContainer: UIView!
	
	weak var delegate: SendReasonProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		reasonTextView.layer.borderColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1).cgColor
		
		shadowContainer.layer.cornerRadius = 10
		shadowContainer.layer.masksToBounds = true
		
		shadowContainer.backgroundColor = UIColor.white
		shadowContainer.layer.shadowColor = UIColor.lightGray.cgColor
		shadowContainer.layer.shadowOpacity = 0.5
		shadowContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
		shadowContainer.layer.shadowRadius = 6.0
		shadowContainer.layer.masksToBounds = false
	}
    
	@IBAction func submitReason(_ sender: Any) {
		delegate?.sendReason(self.reasonTextView.text)
		
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func dismiss(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
