//
//  LastLoggedInUserDatabaseContract.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public protocol LastLoggedInUserDatabaseContract {
    func getLastLoggedInUser(success: (User) -> Void, failure: (String) -> Void)
    
    func setLastLoggedInUser(user: User, success: (User) -> Void, failure: (String) -> Void)
    
}
