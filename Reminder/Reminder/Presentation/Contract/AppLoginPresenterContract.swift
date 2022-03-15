//
//  AppLoginPresenterContract.swift
//  Reminder
//
//  Created by Arun Kumar on 25/02/22.
//

import Foundation
import AppKit
import ReminderBackEnd

protocol AppLoginPresenterContract {
    var appLoginViewController: AppLoginViewControllerContract? { get set }
    
    func createUser(username: String, password: String, imageURL: URL?, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void)
    
    func getAllUsers(onSuccess success: @escaping ([User]) -> Void, onFailure failure: @escaping (String) -> Void)
    
    func getLastLoggedInUser(onSuccess success: @escaping (User) -> Void, onFailure failure: @escaping (String) -> Void)
    
    func setLastLoggedInUser(user: User)
}
