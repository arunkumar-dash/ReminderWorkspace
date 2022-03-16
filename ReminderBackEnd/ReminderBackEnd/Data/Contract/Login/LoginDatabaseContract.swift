//
//  LoginDatabaseContract.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public protocol LoginDatabaseContract {
    func createUser(username: String, password: String, imageURL: URL?, success: (String) -> Void, failure: (String) -> Void)
    
    func changePassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void)
    
    func getAllUsers(success: ([User]) -> Void, failure: (String) -> Void)
    
    func removeUser(username: String, success: (String) -> Void, failure: (String) -> Void)
    
    func doesUserExists(username: String, success: (String) -> Void, failure: (String) -> Void)
    
    func isCorrectPassword(username: String, password: String, success: (String) -> Void, failure: (String) -> Void)
}
