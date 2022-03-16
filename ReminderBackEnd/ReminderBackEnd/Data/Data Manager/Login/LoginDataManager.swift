//
//  LoginDatamanager.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class LoginDataManager {
    var database: LoginDatabaseContract
    
    public init(database: LoginDatabaseContract) {
        self.database = database
    }
}
    
extension LoginDataManager: GetAllUsersDataManagerContract {
    public func getAllUsers(success: @escaping ([User]) -> Void, failure: @escaping (GetAllUsersError) -> Void) {
        database.getAllUsers(success: {
            [weak self]
            (users) in
            self?.getAllUsersSuccess(users: users, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.getAllUsersFailure(message: message, callback: failure)
        })
    }
    
    private func getAllUsersSuccess(users: [User], callback: ([User]) -> Void) {
        callback(users)
    }
    
    private func getAllUsersFailure(message: String, callback: (GetAllUsersError) -> Void) {
        if message == "No Database Connection" {
            let error = GetAllUsersError(status: .networkUnavailable)
            callback(error)
        } else if message == "No User Found" {
            let error = GetAllUsersError(status: .unknownError)
            callback(error)
        }
    }
}
extension LoginDataManager: CreateUserDataManagerContract {
    public func createUser(username: String, password: String, imageURL: URL?, success: @escaping (String) -> Void, failure: @escaping (CreateUserError) -> Void) {
        database.createUser(username: username, password: password, imageURL: imageURL, success: {
            [weak self]
            (username) in
            self?.createUserSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.createUserFailure(message: message, callback: failure)
        })
    }
    
    private func createUserSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func createUserFailure(message: String, callback: (CreateUserError) -> Void) {
        if message == "No Database Connection" {
            let error = CreateUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "Creation Failed" {
            let error = CreateUserError(status: .unknownError)
            callback(error)
        } else if message == "User Already Exists" {
            let error = CreateUserError(status: .unknownError)
            callback(error)
        }
    }
}
extension LoginDataManager: IsCorrectPasswordDataManagerContract {
    public func isCorrectPassword(username: String, password: String, success: @escaping (String) -> Void, failure: @escaping (IsCorrectPasswordError) -> Void) {
        database.isCorrectPassword(username: username, password: password, success: {
            [weak self]
            (username) in
            self?.isCorrectPasswordSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.isCorrectPasswordFailure(message: message, callback: failure)
        })
    }
    
    private func isCorrectPasswordSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func isCorrectPasswordFailure(message: String, callback: (IsCorrectPasswordError) -> Void) {
        if message == "No Database Connection" {
            let error = IsCorrectPasswordError(status: .networkUnavailable)
            callback(error)
        } else if message == "User Name Not Found" {
            let error = IsCorrectPasswordError(status: .authenticationFailure)
            callback(error)
        } else if message == "Password Incorrect" {
            let error = IsCorrectPasswordError(status: .authenticationFailure)
            callback(error)
        }
    }
}
extension LoginDataManager: RemoveUserDataManagerContract {
    public func removeUser(username: String, success: @escaping (String) -> Void, failure: @escaping (RemoveUserError) -> Void) {
        database.removeUser(username: username, success: {
            [weak self]
            (username) in
            self?.removeUserSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.removeUserFailure(message: message, callback: failure)
        })
    }
    
    private func removeUserSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func removeUserFailure(message: String, callback: (RemoveUserError) -> Void) {
        if message == "No Database Connection" {
            let error = RemoveUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "Deletion Failed" {
            let error = RemoveUserError(status: .unknownError)
            callback(error)
        }
    }
}
extension LoginDataManager: ChangePasswordDataManagerContract {
    
    public func changePassword(username: String, password: String, success: @escaping (String) -> Void, failure: @escaping (ChangePasswordError) -> Void) {
        database.changePassword(username: username, password: password, success: {
            [weak self]
            (username) in
            self?.changePasswordSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.changePasswordFailure(message: message, callback: failure)
        })
    }
    
    private func changePasswordSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func changePasswordFailure(message: String, callback: (ChangePasswordError) -> Void) {
        if message == "No Database Connection" {
            let error = ChangePasswordError(status: .networkUnavailable)
            callback(error)
        } else if message == "Updation Failed" {
            let error = ChangePasswordError(status: .unknownError)
            callback(error)
        }
    }
}
extension LoginDataManager: DoesUserExistsDataManagerContract {
    public func doesUserExists(username: String, success: @escaping (String) -> Void, failure: @escaping (DoesUserExistsError) -> Void) {
        database.doesUserExists(username: username, success: {
            [weak self]
            (username) in
            self?.doesUserExistsSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.doesUserExistsFailure(message: message, callback: failure)
        })
    }
    
    private func doesUserExistsSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func doesUserExistsFailure(message: String, callback: (DoesUserExistsError) -> Void) {
        if message == "No Database Connection" {
            let error = DoesUserExistsError(status: .networkUnavailable)
            callback(error)
        } else if message == "User Does Not Exists" {
            let error = DoesUserExistsError(status: .unknownError)
            callback(error)
        }
    }
}
