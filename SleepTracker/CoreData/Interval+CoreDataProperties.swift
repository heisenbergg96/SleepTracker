//
//  Interval+CoreDataProperties.swift
//  SleepTracker
//
//  Created by Vikhyath on 27/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//
//

import Foundation
import CoreData


extension Interval {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Interval> {
        return NSFetchRequest<Interval>(entityName: "Interval")
    }

    @NSManaged public var isDisturbed: Bool
    @NSManaged public var startTime: Int32
    @NSManaged public var stopTime: Int32
    @NSManaged public var session: Session?

}
