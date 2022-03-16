//
//  AppLoginPresenter.swift
//  Reminder
//
//  Created by Arun Kumar on 23/02/22.
//

import Foundation
import AppKit
import ReminderBackEnd

public class AppLoginPresenter: AppLoginPresenterContract {
    weak var appLoginViewController: AppLoginViewControllerContract?
    var createUser: CreateUser?
    var getAllUsers: GetAllUsers?
    var getLastLoggedInUser: GetLastLoggedInUser?
    var setLastLoggedInUser: SetLastLoggedInUser?
    deinit {
        
    }
    
    func createUser(username: String, password: String, imageURL: URL?, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void) {
        
        let database = LoginDatabaseService()
        let dataManager = LoginDataManager(database: database)
        createUser = CreateUser(dataManager: dataManager)
        let request = CreateUserRequest(username: username, password: password, imageURL: imageURL)
        createUser?.execute(request: request, onSuccess: {
            (response) in
            success(response.username)
        }, onFailure: {
            (error) in
            if error.status == CreateUserError.Status.unknownError {
                failure("User name taken")
            } else {
                failure("Creation failed")
            }
        })
    }
    
    func getAllUsers(onSuccess success: @escaping ([User]) -> Void, onFailure failure: @escaping (String) -> Void) {
        let database = LoginDatabaseService()
        let dataManager = LoginDataManager(database: database)
        getAllUsers = GetAllUsers(dataManager: dataManager)
        let success = {
            (response: GetAllUsersResponse) in
            success(response.users)
        }
        let failure = {
            (error: GetAllUsersError) in
            if error.status == .unknownError {
                failure("No Previous Users Found")
            } else if error.status == .networkUnavailable {
                failure("No Database Connection")
            }
        }
        let request = GetAllUsersRequest()
        getAllUsers?.execute(request: request, onSuccess: success, onFailure: failure)
    }
    
    func getLastLoggedInUser(onSuccess success: @escaping (User) -> Void, onFailure failure: @escaping (String) -> Void) {
        let database = LastLoggedInUserDatabaseService()
        let dataManager = LastLoggedInUserDataManager(database: database)
        getLastLoggedInUser = GetLastLoggedInUser(dataManager: dataManager)
        let success = {
            (response: GetLastLoggedInUserResponse) in
            success(response.user)
        }
        let failure = {
            (error: GetLastLoggedInUserError) in
            if error.status == .unknownError {
                failure("No Last Logged In User Found")
            } else if error.status == .networkUnavailable {
                failure("No Database Connection")
            }
        }
        let request = GetLastLoggedInUserRequest()
        getLastLoggedInUser?.execute(request: request, onSuccess: success, onFailure: failure)
    }
    
    func setLastLoggedInUser(user: User) {
        let database = LastLoggedInUserDatabaseService()
        let dataManager = LastLoggedInUserDataManager(database: database)
        setLastLoggedInUser = SetLastLoggedInUser(dataManager: dataManager)
        let success = {
            (response: SetLastLoggedInUserResponse) in
            print("Last logged in User: \(response.user.username)")
        }
        let failure = {
            (error: SetLastLoggedInUserError) in
            if error.status == .unknownError {
                print("Failed to set last logged in user")
            } else if error.status == .networkUnavailable {
                print("No Database Connection")
            }
        }
        let request = SetLastLoggedInUserRequest(user: user)
        setLastLoggedInUser?.execute(request: request, onSuccess: success, onFailure: failure)
    }
}
