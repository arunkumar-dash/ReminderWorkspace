//
//  SetLastLoggedInUserDatabaseService.swift
//  Reminder
//
//  Created by Arun Kumar on 07/03/22.
//

import Foundation

public class SetLastLoggedInUserDatabaseService: SetLastLoggedInUserDatabaseContract {
    public init() {
        
    }
    
    public func setLastLoggedInUser(user: User, success: (User) -> Void, failure: (String) -> Void) {
        var constants = Constants()
        constants.lastLoggedInUser = user
        if constants.lastLoggedInUser?.username == user.username {
            success(user)
        } else {
            failure("Updation Failed")
        }
    }
}
