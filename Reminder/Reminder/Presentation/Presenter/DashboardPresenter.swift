//
//  DashboardPresenter.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import ReminderBackEnd

class DashboardPresenter: DashboardPresenterContract {
    
    weak var dashboardViewController: DashboardViewControllerContract?
    let reminderDataManager: ReminderDataManager
    var getLastLoggedInUserUseCase: GetLastLoggedInUser?
    var addReminderUseCase: AddReminder?
    var router: ReminderRouterContract?
    
    init() {
        print("Dashboard presenter init")
        let reminderDatabase = ReminderDatabaseService()
        self.reminderDataManager = ReminderDataManager(database: reminderDatabase)
    }
    
    deinit {
        print("Dashboard presenter deinit")
    }
    
    func getLastLoggedInUserImageURL(success: @escaping (URL?) -> Void, failure: @escaping (String) -> Void) {
        getLastLoggedInUserUseCase = GetLastLoggedInUser(dataManager: reminderDataManager)
        let request = GetLastLoggedInUserRequest()
        getLastLoggedInUserUseCase?.run(request: request, success: {
            (response: GetLastLoggedInUserResponse) in
            success(response.user.imageURL)
        }, failure: {
            (error: GetLastLoggedInUserError) in
            if error.status == .networkUnavailable {
                failure("No database connection")
            } else if error.status == .unknownError {
                failure("No user found")
            }
        })
    }
    
    func changeViewControllerToLogin() {
        router?.changeViewControllerToLogin()
    }
    
    func addReminder(title: String, description: String, date: Date, repeatPattern: RepeatPattern, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        let addReminderSuccess: (String) -> Void = {
            [weak self]
            (username: String) in
            self?.getUsernameSuccess(username: username, title: title, description: description, date: date, repeatPattern: repeatPattern, success: success, failure: failure)
        }
        let addReminderFailure: (String) -> Void = {
            (message: String)
            in
            failure("Invalid User")
            print(message, "while getting username from database")
        }
        getLastLoggedInUserUsername(success: addReminderSuccess, failure: addReminderFailure)
    }
    
    private func getUsernameSuccess(username: String, title: String, description: String, date: Date, repeatPattern: RepeatPattern, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        self.addReminderUseCase = AddReminder(dataManager: self.reminderDataManager)
        let reminder = Reminder(addedTime: Date.now, title: title, description: description, eventTime: date, repeatTiming: repeatPattern)
        let request = AddReminderRequest(username: username, reminder: reminder)
        let success = {
            (response: AddReminderResponse)
            in
            print(response.reminder, "added.")
            success()
        }
        let failure = {
            (error: AddReminderError)
            in
            if error.status == .unknownError {
                failure("Failed to create Reminder!")
            } else if error.status == .networkUnavailable {
                failure("Database connection failed!")
            }
        }
        self.addReminderUseCase?.run(request: request, success: success, failure: failure)
    }
    
    private func getLastLoggedInUserUsername(success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
        getLastLoggedInUserUseCase = GetLastLoggedInUser(dataManager: reminderDataManager)
        let request = GetLastLoggedInUserRequest()
        getLastLoggedInUserUseCase?.run(request: request, success: {
            (response: GetLastLoggedInUserResponse) in
            success(response.user.username)
        }, failure: {
            (error: GetLastLoggedInUserError) in
            if error.status == .networkUnavailable {
                failure("No database connection")
            } else if error.status == .unknownError {
                failure("No user found")
            }
        })
    }
}
