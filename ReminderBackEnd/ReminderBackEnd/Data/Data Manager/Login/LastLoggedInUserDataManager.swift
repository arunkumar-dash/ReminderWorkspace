//
//  LastLoggedInUserDataManager.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class LastLoggedInUserDataManager {
    var database: LastLoggedInUserDatabaseContract
    
    public init(database: LastLoggedInUserDatabaseContract) {
        self.database = database
    }
}

extension LastLoggedInUserDataManager: GetLastLoggedInUserDataManagerContract {
    public func getLastLoggedInUser(success: @escaping (User) -> Void, failure: @escaping (GetLastLoggedInUserError) -> Void) {
        database.getLastLoggedInUser(success: {
            [weak self]
            (user) in
            self?.getLastLoggedInUserSuccess(user: user, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.getLastLoggedInUserFailure(message: message, callback: failure)
        })
    }
    
    private func getLastLoggedInUserSuccess(user: User, callback: (User) -> Void) {
        callback(user)
    }
    
    private func getLastLoggedInUserFailure(message: String, callback: (GetLastLoggedInUserError) -> Void) {
        if message == "No Database Connection" {
            let error = GetLastLoggedInUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "No User Found" {
            let error = GetLastLoggedInUserError(status: .unknownError)
            callback(error)
        }
    }
}

extension LastLoggedInUserDataManager: SetLastLoggedInUserDataManagerContract {
    public func setLastLoggedInUser(user: User, success: @escaping (User) -> Void, failure: @escaping (SetLastLoggedInUserError) -> Void) {
        database.setLastLoggedInUser(user: user, success: {
            [weak self]
            (user) in
            self?.success(user: user, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.failure(message: message, callback: failure)
        })
    }
    
    private func success(user: User, callback: (User) -> Void) {
        callback(user)
    }
    
    private func failure(message: String, callback: (SetLastLoggedInUserError) -> Void) {
        if message == "No Database Connection" {
            let error = SetLastLoggedInUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "Updation Failed" {
            let error = SetLastLoggedInUserError(status: .unknownError)
            callback(error)
        }
    }
}
