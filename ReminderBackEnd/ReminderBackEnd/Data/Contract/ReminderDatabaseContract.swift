//
//  ReminderDatabaseContract.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public protocol ReminderDatabaseContract {
    func createUser(username: String, password: String, imageURL: URL?, success: (String) -> Void, failure: (String) -> Void)
    
    func changePassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void)
    
    func getAllUsers(success: ([User]) -> Void, failure: (String) -> Void)
    
    func removeUser(username: String, success: (String) -> Void, failure: (String) -> Void)
    
    func doesUserExists(username: String, success: (String) -> Void, failure: (String) -> Void)
    
    func isCorrectPassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void)
    
    func getLastLoggedInUser(success: (User) -> Void, failure: (String) -> Void)
    
    func setLastLoggedInUser(user: User, success: (User) -> Void, failure: (String) -> Void)
    
    func addReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void)
    
    func deleteReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void)
    
    func getReminderList(username: String, success: ([Reminder]) -> Void, failure: (String) -> Void)
    
    func updateReminder(username: String, reminder: Reminder, success: (Reminder) -> Void, failure: (String) -> Void)
}
