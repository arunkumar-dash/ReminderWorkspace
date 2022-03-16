//
//  LoginDatabaseService.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class LoginDatabaseService: LoginDatabaseContract {
    private let credentialsDB: UserDatabase
    public init() {
        credentialsDB = UserDatabase()
    }
    public func createUser(username: String, password: String, imageURL: URL?, success: (String) -> Void, failure: (String) -> Void) {
        if let _ = credentialsDB.getPassword(forUsername: username) {
            failure("User Already Exists")
        } else if credentialsDB.insert(username: username, password: password, imageURL: imageURL) {
            success(username)
        } else {
            failure("Creation Failed")
        }
    }
    
    public func getAllUsers(success: ([User]) -> Void, failure: (String) -> Void) {
        let allUsers = credentialsDB.getAllUsers()
        if allUsers.count > 0 {
            success(allUsers)
        } else {
            failure("No User Found")
        }
    }
    
    public func doesUserExists(username: String, success: (String) -> Void, failure: (String) -> Void) {
        if let _ = credentialsDB.getPassword(forUsername: username) {
            success(username)
        } else {
            failure("User Does Not Exists")
        }
    }
    
    public func changePassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void) {
        if credentialsDB.update(password: password, for: username) {
            success(username)
        } else {
            failure("Updation Failed")
        }
    }
    
    public func removeUser(username: String, success: (String) -> Void, failure: (String) -> Void) {
        if credentialsDB.delete(username: username) {
            success(username)
        } else {
            failure("Deletion Failed")
        }
    }
    
    public func isCorrectPassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void) {
        if let passwordFromDB = credentialsDB.getPassword(forUsername: username) {
            if passwordFromDB == password {
                success(username)
            } else {
                failure("Password Incorrect")
            }
        } else {
            failure("User Name Not Found")
        }
    }
}
