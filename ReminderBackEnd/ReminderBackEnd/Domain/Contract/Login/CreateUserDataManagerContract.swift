//
//  CreateUserDataManagerContract.swift
//  Reminder
//
//  Created by Arun Kumar on 07/03/22.
//

import Foundation

public protocol CreateUserDataManagerContract {
    func createUser(username: String, password: String, imageURL: URL?, success: @escaping (String) -> Void, failure: @escaping (CreateUserError) -> Void)
}
