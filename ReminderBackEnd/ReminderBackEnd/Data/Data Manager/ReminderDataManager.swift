//
//  ReminderDataManager.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class ReminderDataManager {
    var database: ReminderDatabaseContract
    
    public init(database: ReminderDatabaseContract) {
        self.database = database
    }
}
extension ReminderDataManager: AddReminderDataManagerContract {
    
    public func addReminder(username: String, reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (AddReminderError) -> Void) {
        database.addReminder(username: username, reminder: reminder, success: {
            [weak self]
            (reminder) in
            self?.addReminderSuccess(reminder: reminder, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.addReminderFailure(message: message, callback: failure)
        })
    }
    
    private func addReminderSuccess(reminder: Reminder, callback: (Reminder) -> Void) {
        callback(reminder)
    }
    
    private func addReminderFailure(message: String, callback: (AddReminderError) -> Void) {
        if message == "Addition Failed" {
            let error = AddReminderError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = AddReminderError(status: .networkUnavailable)
            callback(error)
        }
    }
}
 
extension ReminderDataManager: GetReminderListDataManagerContract {
    public func getReminderList(username: String, success: ([Reminder]) -> Void, failure: (GetReminderListError) -> Void) {
        database.getReminderList(username: username, success: {
            [weak self]
            (reminders) in
            self?.getReminderListSuccess(reminders: reminders, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.getReminderListFailure(message: message, callback: failure)
        })
    }
    
    private func getReminderListSuccess(reminders: [Reminder], callback: ([Reminder]) -> Void) {
        callback(reminders)
    }
    
    private func getReminderListFailure(message: String, callback: (GetReminderListError) -> Void) {
        if message == "No Data" {
            let error = GetReminderListError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = GetReminderListError(status: .networkUnavailable)
            callback(error)
        }
    }
}
 
extension ReminderDataManager: UpdateReminderDataManagerContract {
    public func updateReminder(username: String, reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (UpdateReminderError) -> Void) {
        database.updateReminder(username: username, reminder: reminder, success: {
            [weak self]
            (reminder) in
            self?.updateReminderSuccess(reminder: reminder, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.updateReminderFailure(message: message, callback: failure)
        })
    }
    
    private func updateReminderSuccess(reminder: Reminder, callback: (Reminder) -> Void) {
        callback(reminder)
    }
    
    private func updateReminderFailure(message: String, callback: (UpdateReminderError) -> Void) {
        if message == "Updation Failed" {
            let error = UpdateReminderError(status: .unknownError)
            callback(error)
        } else if message == "Invalid Data" {
            let error = UpdateReminderError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = UpdateReminderError(status: .networkUnavailable)
            callback(error)
        }
    }
}
 
extension ReminderDataManager: DeleteReminderDataManagerContract {
    public func deleteReminder(username: String, reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (DeleteReminderError) -> Void) {
        database.deleteReminder(username: username, reminder: reminder, success: {
            [weak self]
            (reminder) in
            self?.deleteReminderSuccess(reminder: reminder, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.deleteReminderFailure(message: message, callback: failure)
        })
    }
    
    private func deleteReminderSuccess(reminder: Reminder, callback: (Reminder) -> Void) {
        callback(reminder)
    }
    
    private func deleteReminderFailure(message: String, callback: (DeleteReminderError) -> Void) {
        if message == "Deletion Failed" {
            let error = DeleteReminderError(status: .unknownError)
            callback(error)
        } else if message == "Invalid Data" {
            let error = DeleteReminderError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = DeleteReminderError(status: .networkUnavailable)
            callback(error)
        }
    }
}
