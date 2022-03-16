//
//  ReminderDatabaseService.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class ReminderDatabaseService: ReminderDatabaseContract {
    
    public init() {
    }
    
    public func addReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void) {
        let reminderDatabase = ReminderDatabase(for: username)
        if reminderDatabase.create(element: reminder) {
            success(reminder)
        } else {
            failure("Addition Failed")
        }
    }
    
    public func getReminderList(username: String, success: ([Reminder]) -> Void, failure: (String) -> Void) {
        let reminderDatabase = ReminderDatabase(for: username)
        let optionalReminders = reminderDatabase.getAllRows()
        var reminders: [Reminder] = []
        for reminder in optionalReminders {
            if let reminder = reminder {
                reminders.append(reminder)
            }
        }
        if reminders.count > 0 {
            success(reminders)
        } else {
            failure("No Data")
        }
    }
    
    public func updateReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void) {
        let reminderDatabase = ReminderDatabase(for: username)
        if let id = reminder.id {
            if reminderDatabase.update(id: id, element: reminder) {
                success(reminder)
            } else {
                failure("Updation Failed")
            }
        } else {
            failure("Invalid Data")
        }
    }
    
    public func deleteReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void) {
        let reminderDatabase = ReminderDatabase(for: username)
        if let id = reminder.id {
            if reminderDatabase.delete(id: id) {
                success(reminder)
            } else {
                failure("Deletion Failed")
            }
        } else {
            failure("Invalid Data")
        }
    }
}
