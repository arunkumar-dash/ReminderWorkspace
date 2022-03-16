//
//  ReminderDatabaseContract.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public protocol ReminderDatabaseContract {
    func addReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void)
    func deleteReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void)
    func getReminderList(username: String, success: ([Reminder]) -> Void, failure: (String) -> Void)
    func updateReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void)
}
