//
//  IsCorrectPassword.swift
//  Reminder
//
//  Created by Arun Kumar on 07/03/22.
//

import Foundation

public protocol IsCorrectPasswordDataManagerContract {
    func isCorrectPassword(username: String, password: String, success: @escaping (String) -> Void, failure: @escaping (IsCorrectPasswordError) -> Void)
}
