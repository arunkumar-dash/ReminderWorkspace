//
//  ReminderDatabaseService.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class ReminderDatabaseService: ReminderDatabaseContract {
    
    private let reminderDatabase: ReminderDatabase
    public init() {
        reminderDatabase = ReminderDatabase.shared
    }
    public func createUser(username: String, password: String, imageURL: URL?, success: (String) -> Void, failure: (String) -> Void) {
        if let _ = reminderDatabase.getPassword(forUsername: username) {
            failure("User Already Exists")
        } else if reminderDatabase.createUser(username: username, password: password, imageURL: imageURL) {
            success(username)
        } else {
            failure("Creation Failed")
        }
    }
    
    public func getAllUsers(success: ([User]) -> Void, failure: (String) -> Void) {
        let allUsers = reminderDatabase.getAllUsers()
        if allUsers.count > 0 {
            success(allUsers)
        } else {
            failure("No User Found")
        }
    }
    
    public func doesUserExists(username: String, success: (String) -> Void, failure: (String) -> Void) {
        if let _ = reminderDatabase.getPassword(forUsername: username) {
            success(username)
        } else {
            failure("User Does Not Exists")
        }
    }
    
    public func changePassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void) {
        if reminderDatabase.editUser(password: password, for: username) {
            success(username)
        } else {
            failure("Updation Failed")
        }
    }
    
    public func removeUser(username: String, success: (String) -> Void, failure: (String) -> Void) {
        if reminderDatabase.removeUser(username: username) {
            success(username)
        } else {
            failure("Deletion Failed")
        }
    }
    
    public func isCorrectPassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void) {
        if let passwordFromDB = reminderDatabase.getPassword(forUsername: username) {
            if passwordFromDB == password {
                success(username)
            } else {
                failure("Password Incorrect")
            }
        } else {
            failure("User Name Not Found")
        }
    }
    
    public func addReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void) {
        if reminderDatabase.createReminder(for: username, reminder: reminder) {
            success(reminder)
        } else {
            failure("Addition Failed")
        }
    }
    
    public func getReminderList(username: String, success: ([Reminder]) -> Void, failure: (String) -> Void) {
        let optionalReminders = reminderDatabase.getAllReminders(for: username)
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
        if let id = reminder.id {
            if reminderDatabase.updateReminder(username: username, id: id, element: reminder) {
                success(reminder)
            } else {
                failure("Updation Failed")
            }
        } else {
            failure("Invalid Data")
        }
    }
    
    public func deleteReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void) {
        if let id = reminder.id {
            if reminderDatabase.deleteReminder(for: username, id: id) {
                success(reminder)
            } else {
                failure("Deletion Failed")
            }
        } else {
            failure("Invalid Data")
        }
    }
    
    public func getLastLoggedInUser(success: (User) -> Void, failure: (String) -> Void) {
        let lastLoggedInUser = reminderDatabase.getLastLoggedInUser()
        if let lastLoggedInUser = lastLoggedInUser {
            success(lastLoggedInUser)
        } else {
            failure("No User Found")
        }
    }
    
    public func setLastLoggedInUser(user: User, success: (User) -> Void, failure: (String) -> Void) {
        if reminderDatabase.setLastLoggedInUser(user: user) {
            success(user)
        } else {
            failure("Updation Failed")
        }
    }
}
