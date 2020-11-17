//
//  CDPlayer+CoreDataClass.swift
//  
//
//  Created by senthil on 06/10/20.
//
//

import Foundation
import CoreData

@objc(CDPlayer)
public class CDPlayer: NSManagedObject {
	func parameters() -> [String: Any] {
		return [
			"id":self.subscriberID,
			"name":self.name ?? "",
			"gender":self.gender,
			"dob":self.dob ?? "",
			"isdCode":self.isdCode ?? "",
			"mobileNumber":self.mobileNumber ?? "",
			"email":self.email ?? "",
			"position":self.position ?? ""
		]
	}
}
