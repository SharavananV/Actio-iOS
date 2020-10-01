//
//  EventRegistration+CoreDataProperties.swift
//  
//
//  Created by senthil on 01/10/20.
//
//

import Foundation
import CoreData


extension EventRegistration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventRegistration> {
        return NSFetchRequest<EventRegistration>(entityName: "EventRegistration")
    }

    @NSManaged public var eventID: String?
    @NSManaged public var registerBy: String?
    @NSManaged public var teamName: String?
    @NSManaged public var ageGroup: String?
    @NSManaged public var cityID: String?
    @NSManaged public var coachName: String?
    @NSManaged public var coachIsd: String?
    @NSManaged public var coachMobile: String?
    @NSManaged public var coachEmail: String?
    @NSManaged public var registrationID: String?
    @NSManaged public var isCoach: Bool

}
