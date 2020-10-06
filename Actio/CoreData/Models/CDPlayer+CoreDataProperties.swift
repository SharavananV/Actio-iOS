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
	
	@nonobjc public class func fetchRequest(withID id: Int, eventId: Int, subscriberId: Int) -> NSFetchRequest<CDPlayer> {
		let fetchRequest = NSFetchRequest<CDPlayer>(entityName: "CDPlayer")
		fetchRequest.predicate = NSPredicate(format: "id == %lld AND eventId == %lld AND subscriberId == %lld", id, eventId, subscriberId)
		
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
    @NSManaged public var subscriberId: Int64

}
