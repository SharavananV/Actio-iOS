//
//  CDPlayer+CoreDataProperties.swift
//  
//
//  Created by senthil on 06/10/20.
//
//

import Foundation
import CoreData


extension CDPlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPlayer> {
        return NSFetchRequest<CDPlayer>(entityName: "CDPlayer")
    }
	
	@nonobjc public class func fetchRequest(withID id: Int, eventId: Int, registrationID: Int) -> NSFetchRequest<CDPlayer> {
		let fetchRequest = NSFetchRequest<CDPlayer>(entityName: "CDPlayer")
		fetchRequest.predicate = NSPredicate(format: "id == %lld AND eventId == %lld AND registrationId == %lld", id, eventId, registrationID)
		
		return fetchRequest
	}
	
	@nonobjc public class func fetchRequest(eventId: Int) -> NSFetchRequest<NSFetchRequestResult> {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDPlayer")
		fetchRequest.predicate = NSPredicate(format: "eventId == %lld", eventId)
		
		return fetchRequest
	}
	
	@nonobjc public class func fetchRequestForYesterday() -> NSFetchRequest<NSFetchRequestResult> {
		var dateComponents = DateComponents()
		dateComponents.setValue(-1, for: .day)
		
		let yesterday = Calendar.current.date(byAdding: dateComponents, to: Date())
				
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDPlayer")
		fetchRequest.predicate = NSPredicate(format: "createdAt > %@", yesterday! as NSDate)
		
		return fetchRequest
	}

    @NSManaged public var name: String?
    @NSManaged public var gender: Int16
    @NSManaged public var dob: String?
    @NSManaged public var isdCode: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var email: String?
    @NSManaged public var position: String?
    @NSManaged public var id: Int64
    @NSManaged public var eventId: Int64
    @NSManaged public var registrationId: Int64
	@NSManaged public var createdAt: Date?

}
