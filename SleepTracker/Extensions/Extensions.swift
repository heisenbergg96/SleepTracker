//
//  DateExtension.swift
//  Sensors
//
//  Created by Vikhyath on 12/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import Foundation
import UIKit

enum CompnentType {
    case hour
    case minute
    case second
}

enum Time {
    case time
    case date
}

extension Date {
    
    init(date: NSDate) {
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
    
    static func getTimeComponents(from date: Date) -> (Int, Int, Int) {
        
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        return (hour, minutes, seconds)
    }
    
    static func getHourMinuteSecond(from seconds: Int) -> (Int, Int, Int) {
        
        let hour = seconds / 3600
        let minute = seconds / 60
        let sec = seconds % 60
        
        return (hour, minute, sec)
    }
    
    var localizedDescription: String {
        return description(with: .current)
    }
    
    
    static func tomorrow() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        
        let now = Date() // Current date
        guard let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now) else { return Date() } // Add the DateComponents
        
        return tomorrow
    }
    
    var today: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getDateComponenets() -> DateComponents {
        
        return Calendar.current.dateComponents([.hour, .minute], from: self)
    }
    
    static func getDifference(date1: Date, date2: Date) -> DateComponents {
        
        return Calendar.current.dateComponents([.hour, .minute], from: date1, to: date2)
    }
    
    static func getTimeInFormat(hour: Int, minute: Int) -> String {
        
        var forenoonAfternoon = ""
        var time = ""
        var hourFormated = hour
        if hourFormated > 12 {
            hourFormated = hour - 12
            forenoonAfternoon = "PM"
        } else {
            if hourFormated == 12 {
                forenoonAfternoon = "PM"
            } else {
                forenoonAfternoon = "AM"
            }
        }
        if hourFormated < 10 {
            if minute < 10 {
                time = "0\(hourFormated):0\(minute) \(forenoonAfternoon)"
            } else {
                time = "0\(hourFormated):\(minute) \(forenoonAfternoon)"
            }
        } else {
            if minute < 10 {
                time = "\(hourFormated):0\(minute) \(forenoonAfternoon)"
            } else {
                time = "\(hourFormated):\(minute) \(forenoonAfternoon)"
            }
        }
        
        return time
    }
}


extension Int {
    
    func getHourMinuteSecond(type: [Calendar.Component] = [.hour, .minute, .second]) -> String {
        
        var minute = self / 60
        let sec = self % 60
        let hour = minute / 60
        minute = minute % 60
        
        if type.count == 2 {
            return "\(minute)m \(sec)s"
        } else if type.count == 3 {
            return "\(hour)h \(minute)m \(sec)s"
        } else {
            return "\(hour)h \(minute)m"
        }
    }
    
}

extension Double {
    
    func getReadableDate(type: Time) -> String? {
        
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        
        if type == .time {
            dateFormatter.dateFormat = "h:mm:ss a"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "MMM d yyyy"
            return dateFormatter.string(from: date)
        }
        
    }
    
    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}
