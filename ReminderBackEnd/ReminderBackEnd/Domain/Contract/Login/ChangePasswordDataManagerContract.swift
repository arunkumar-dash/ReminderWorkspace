//
//  ChangePasswordDataManagerContract.swift
//  Reminder
//
//  Created by Arun Kumar on 07/03/22.
//

import Foundation

public protocol ChangePasswordDataManagerContract {
    func changePassword(username: String, password: String, success: @escaping (String) -> Void, failure: @escaping (ChangePasswordError) -> Void)
}
