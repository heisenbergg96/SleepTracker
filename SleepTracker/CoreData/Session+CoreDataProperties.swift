//
//  Session+CoreDataProperties.swift
//  SleepTracker
//
//  Created by Vikhyath on 27/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var start: Int32
    @NSManaged public var stop: Int32
    @NSManaged public var phoneCallDuration: Int16
    @NSManaged public var intervals: NSSet?
    @NSManaged public var sleep: Sleep?

}

// MARK: Generated accessors for intervals
extension Session {

    @objc(addIntervalsObject:)
    @NSManaged public func addToIntervals(_ value: Interval)

    @objc(removeIntervalsObject:)
    @NSManaged public func removeFromIntervals(_ value: Interval)

    @objc(addIntervals:)
    @NSManaged public func addToIntervals(_ values: NSSet)

    @objc(removeIntervals:)
    @NSManaged public func removeFromIntervals(_ values: NSSet)

}
