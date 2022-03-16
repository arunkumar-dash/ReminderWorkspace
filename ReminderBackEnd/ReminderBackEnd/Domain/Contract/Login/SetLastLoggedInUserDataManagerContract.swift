//
//  SetLastLoggedInUserDataManagerContract.swift
//  Reminder
//
//  Created by Arun Kumar on 08/03/22.
//

import Foundation

public protocol SetLastLoggedInUserDataManagerContract {
    func setLastLoggedInUser(user: User, success: @escaping (User) -> Void, failure: @escaping (SetLastLoggedInUserError) -> Void)
}
