
//  CoreDataManager.swift
//  Sensors
//
//  Created by Vikhyath on 15/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.


import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func insertRecord(sleepData: SleepSession, completion: (Bool, String) -> Void) {
        
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        var intervals = Set<Interval>()
        
        guard let sessionEntity = NSEntityDescription.insertNewObject(forEntityName: "Session", into: context) as? Session else { return }
        sleepData.intervals.forEach { disturbedSleep in
            guard let intervalEntity = NSEntityDescription.insertNewObject(forEntityName: "Interval", into: context) as? Interval else { return }
            intervalEntity.startTime = Int32(disturbedSleep.startTime)
            intervalEntity.stopTime = Int32(disturbedSleep.endTime)
            intervals.insert(intervalEntity)
        }
        sessionEntity.phoneCallDuration = Int16(sleepData.phoneCallDuration)
        sessionEntity.start = Int32(sleepData.startTime)
        sessionEntity.stop = Int32(sleepData.stopTime)
        if !intervals.isEmpty {
            sessionEntity.addToIntervals((intervals as NSSet))
        }
        // Fetch already existing sleep record, if no  such record is found, inserta new record.
        let currentDaysSleep = fetchSleep(by: Int(Date().timeIntervalSince1970/86400) * 86400)
        if currentDaysSleep != nil {
            sessionEntity.sleep = currentDaysSleep
        } else {
            let sleepEntity = NSEntityDescription.insertNewObject(forEntityName: "Sleep", into: context) as? Sleep
            sleepEntity?.date = Int32(Int(Date().timeIntervalSince1970/86400) * 86400)
            sleepEntity?.addToSession(sessionEntity)
        }
        
        do {
            try context.save()
            completion(true, "Successfully inserted")
        } catch {
            completion(false, "Failed to insert")
        }
    }
    
    func fetchData(completion: ([Section], [CGFloat]) -> Void) {
        
        var sleepData: [Section] = []
        var totalSleepDurations = [CGFloat]()
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Sleep>(entityName: "Sleep")
        fetchRequest.returnsObjectsAsFaults = false
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                let sleepDate = Int(data.date)
                var totalNormalSleepDurationInDay = 0
                var rows = [Row]()
                if let sessionsOfDay = data.session as? Set<Session> {
                    sessionsOfDay.forEach { (eachSessionOfDay) in
                        var totalDisturbedSleepIneachSession = 0
                        var totalNormalSleep = 0
                        if let intervalsOfDay = eachSessionOfDay.intervals as? Set<Interval> {
                            intervalsOfDay.forEach({ (disturbedSleepIneachSession) in
                                totalDisturbedSleepIneachSession += Int(disturbedSleepIneachSession.stopTime - disturbedSleepIneachSession.startTime)
                            })
                            totalNormalSleep = Int(eachSessionOfDay.stop - eachSessionOfDay.start - Int32(totalDisturbedSleepIneachSession) - Int32(eachSessionOfDay.phoneCallDuration))
                            totalNormalSleepDurationInDay += totalNormalSleep
                            rows.append(Row(startTime: Int(eachSessionOfDay.start), endTime: Int(eachSessionOfDay.stop), disturbedSleep: totalDisturbedSleepIneachSession, totalSleep: totalNormalSleep, phoneCallDuration: Int(eachSessionOfDay.phoneCallDuration)))
                        }
                    }
                }
                totalSleepDurations.append(CGFloat(totalNormalSleepDurationInDay))
                sleepData.append(Section(date: sleepDate, totalSleepDuration: totalNormalSleepDurationInDay, rows: rows))
            }
            completion(sleepData, totalSleepDurations)
            
        } catch {
            print("Error fetching")
        }
        
    }
    
    func fetchSleep(by date: Int) -> Sleep? {
        
        //Always send start session date because when day crosses sleep duration has to be added to previous day.
        guard let context = appDelegate?.persistentContainer.viewContext else { return nil }
        let fetchRequest = NSFetchRequest<Sleep>(entityName: "Sleep")
        
        let pred = NSPredicate(format: "date == %d", date)
        fetchRequest.predicate = pred
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                return result[0]
            }
            return nil
        } catch {
            print("Could not fetch")
            return nil
        }
    }
    
    func getSleepDetails() {
        
        
    }
}

class Section {
    
    var date: Int
    var totalSleepDuration: Int
    var rows: [Row]
    
    init(date: Int, totalSleepDuration: Int, rows: [Row]) {
        
        self.date = date
        self.totalSleepDuration = totalSleepDuration
        self.rows = rows
    }
}

class Row {
    
    var startTime: Int
    var endTime: Int
    var disturbedSleep: Int
    var totalSleep: Int
    var phoneCallDuration: Int
    
    init(startTime: Int, endTime: Int, disturbedSleep: Int, totalSleep: Int, phoneCallDuration: Int) {
        
        self.disturbedSleep = disturbedSleep
        self.totalSleep = totalSleep
        self.phoneCallDuration = phoneCallDuration
        self.startTime = startTime
        self.endTime = endTime
        
    }
}
