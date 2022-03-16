//
//  LastLoggedInUserDatabaseService.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class LastLoggedInUserDatabaseService: LastLoggedInUserDatabaseContract {
    private var constantsDB: Constants
    
    public init() {
        self.constantsDB = Constants()
    }
    
    public func getLastLoggedInUser(success: (User) -> Void, failure: (String) -> Void) {
        let lastLoggedInUser = constantsDB.lastLoggedInUser
        if let lastLoggedInUser = lastLoggedInUser {
            success(lastLoggedInUser)
        } else {
            failure("No User Found")
        }
    }
    
    public func setLastLoggedInUser(user: User, success: (User) -> Void, failure: (String) -> Void) {
        constantsDB.lastLoggedInUser = user
        if constantsDB.lastLoggedInUser?.username == user.username {
            success(user)
        } else {
            failure("Updation Failed")
        }
    }
}
