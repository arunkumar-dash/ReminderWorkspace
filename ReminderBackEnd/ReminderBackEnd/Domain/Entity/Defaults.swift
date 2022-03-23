//
//  Defaults.swift
//  Reminder
//
//  Created by Arun Kumar on 04/03/22.
//

import Foundation


/// Conforming to this protocol will convert
public protocol Defaults {
    
}

extension Defaults {
    /// Returns the `defaultValue` if the `mainValue` is `nil`, else returns `mainValue`
    ///
    /// - Parameters:
    ///  - mainvalue: The mainValue which is considered if it is not nil
    ///  - defaultValue: The value which should be considered if the `mainValue` is nil
    static func setValue<Element>(mainValue: Element?, defaultValue: Element) -> Element {
        return mainValue ?? defaultValue
    }
}



/// Returns the default values of the `Reminder` parameters
public class ReminderDefaults: Defaults {
    private init() {}
    
    /// Default title for Reminder
    static var title: String {
        get {
            let database = ReminderDatabase.shared
            let title: String
            if let user = database.getLastLoggedInUser() {
                if let reminderTitle = database.getUserConstant(for: user.username, key: "reminderTitle") {
                    title = reminderTitle
                    return "\(title)-\(Date.now.description(with: Locale.current))"
                }
            }
            title = "Untitled"
            return "\(title)-\(Date.now.description(with: Locale.current))"
        }
        set {
            let database = ReminderDatabase.shared
            if let user = database.getLastLoggedInUser() {
                if database.updateUserConstant(for: user.username, key: "reminderTitle", value: newValue) == false {
                    print("Cannot set default reminder title")
                }
            }
        }
    }
    
    /// Default description for Reminder
    static var description: String {
        get {
            let database = ReminderDatabase.shared
            let description: String
            if let user = database.getLastLoggedInUser() {
                if let reminderDescription = database.getUserConstant(for: user.username, key: "reminderDescription") {
                    description = reminderDescription
                    return "\(description)-\(Date.now.description(with: Locale.current))"
                }
            }
            description = "Description"
            return description
        }
        set {
            let database = ReminderDatabase.shared
            if let user = database.getLastLoggedInUser() {
                if database.updateUserConstant(for: user.username, key: "reminderDescription", value: newValue) == false {
                    print("Cannot set default reminder description")
                }
            }
        }
    }
    
    /// Default time when the Reminder rings
    /// Default time set here is one hour(3600 seconds) after the time when Reminder was added
    static var eventTime: Date {
        let database = ReminderDatabase.shared
        let timeInterval: TimeInterval
        if let user = database.getLastLoggedInUser() {
            if let timeIntervalString = database.getUserConstant(for: user.username, key: "reminderTimeInterval") {
                if let timeInterval = Double(timeIntervalString) {
                    return Date.now + timeInterval
                }
            }
        }
        timeInterval = 3600
        return Date.now + timeInterval
    }
    
    /// Pattern when the Reminder repeats
    /// Default pattern is no repetitions
    static var repeatTiming: RepeatPattern {
        get {
            let database = ReminderDatabase.shared
            if let user = database.getLastLoggedInUser() {
                if let repeatPatternString = database.getUserConstant(for: user.username, key: "reminderRepeatPattern") {
                    switch (repeatPatternString) {
                    case "never":
                        return .never
                    case "everyMinute":
                        return .everyMinute
                    case "everyDay":
                        return .everyDay
                    case "everyWeek":
                        return .everyWeek
                    case "everyMonth":
                        return .everyWeek
                    case "everyYear":
                        return .everyYear
                    default:
                        return .never
                    }
                }
            }
            return .never
        }
        set {
            let database = ReminderDatabase.shared
            if let user = database.getLastLoggedInUser() {
                if database.updateUserConstant(for: user.username, key: "reminderRepeatPattern", value: "\(newValue)") == false {
                    print("Cannot set default reminder repeatTiming")
                }
            }
        }
    }
    
    /// Set of `TimeInterval`s when the Reminder should ring before the `eventTime`
    /// By default the reminder rings 30 minutes before the `eventTime`
    static var ringTimeIntervals: Set<TimeInterval> {
        get {
            let database = ReminderDatabase.shared
            if let user = database.getLastLoggedInUser() {
                if let ringTimeIntervalsString = database.getUserConstant(for: user.username, key: "reminderRingTimeIntervals") {
                    let ringTimeIntervals = ringTimeIntervalsString.split(separator: ",").map({Double($0)})
                    var timeIntervals: Set<Double> = []
                    for ringTimeInterval in ringTimeIntervals {
                        if let ringTimeInterval = ringTimeInterval {
                            timeIntervals.insert(ringTimeInterval)
                        }
                    }
                    return timeIntervals
                }
            }
            return Set([3600])
        }
        set {
            var ringTimeIntervalsString = ""
            for interval in newValue {
                ringTimeIntervalsString += String(interval) + ","
            }
            let database = ReminderDatabase.shared
            if let user = database.getLastLoggedInUser() {
                if database.updateUserConstant(for: user.username, key: "reminderRingTimeIntervals", value: ringTimeIntervalsString) == false {
                    print("Cannot set default reminder ringTimeIntervals")
                }
            }
        }
    }
//    let reminderView = ReminderView(self)
    
    static func setDefault(title: String) {
        Self.title = title
    }
    
    static func setDefault(description: String) {
        Self.description = description
    }
    
    static func setDefault(repeatTiming: RepeatPattern) {
        Self.repeatTiming = repeatTiming
    }
    
    static func setDefault(ringTimeIntervals: Set<TimeInterval>) {
        Self.ringTimeIntervals = ringTimeIntervals
    }
    
    static func setValue(title: String?) -> String {
        return title ?? Self.title
    }
    
    static func setValue(description: String?) -> String {
        return description ?? Self.description
    }
    
    static func setValue(eventTime: Date?) -> Date {
        return eventTime ?? Self.eventTime
    }
    
    static func setValue(sound: String?) -> String {
        return sound ?? ""
    }
    
    static func setValue(repeatTiming: RepeatPattern?) -> RepeatPattern {
        return repeatTiming ?? Self.repeatTiming
    }
    
    static func setValue(ringTimeIntervals: Set<TimeInterval>?) -> Set<TimeInterval> {
        return ringTimeIntervals ?? Self.ringTimeIntervals
    }
}
