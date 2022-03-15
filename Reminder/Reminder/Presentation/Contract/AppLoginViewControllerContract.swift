//
//  AppLoginViewControllerContract.swift
//  Reminder
//
//  Created by Arun Kumar on 23/02/22.
//

import Foundation
import AppKit
import ReminderBackEnd

protocol AppLoginViewControllerContract: NSViewController {
    func createUser(_ sender: RegistrationView)
    
    func changeViewToRegistration()
    
    func changeViewToLogin()
    
    func changeViewToSwitchUser()
    
    func navigateBackToPreviousView()
    
    func getAllUsers(success: @escaping ([User]) -> Void, failure: @escaping (String) -> Void)
    
    func getLastLoggedInUser(success: @escaping (User) -> Void, failure: @escaping (String) -> Void)
    
    func setLastLoggedInUser(_ user: User)
    
}
