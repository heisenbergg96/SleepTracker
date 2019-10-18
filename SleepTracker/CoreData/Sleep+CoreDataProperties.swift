//
//  Sleep+CoreDataProperties.swift
//  SleepTracker
//
//  Created by Vikhyath on 27/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//
//

import Foundation
import CoreData


extension Sleep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sleep> {
        return NSFetchRequest<Sleep>(entityName: "Sleep")
    }

    @NSManaged public var date: Int32
    @NSManaged public var session: NSSet?

}

// MARK: Generated accessors for session
extension Sleep {

    @objc(addSessionObject:)
    @NSManaged public func addToSession(_ value: Session)

    @objc(removeSessionObject:)
    @NSManaged public func removeFromSession(_ value: Session)

    @objc(addSession:)
    @NSManaged public func addToSession(_ values: NSSet)

    @objc(removeSession:)
    @NSManaged public func removeFromSession(_ values: NSSet)

}
