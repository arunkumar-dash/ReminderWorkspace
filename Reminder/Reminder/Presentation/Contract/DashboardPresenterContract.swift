//
//  DashboardPresenterContract.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation

protocol DashboardPresenterContract {
    
    
    var dashboardViewController: DashboardViewControllerContract? { get set }
    var router: ReminderRouterContract? { get set }
    func getLastLoggedInUserImageURL(success: @escaping (URL?) -> Void, failure: @escaping (String) -> Void)
    func changeViewControllerToLogin()
    func addReminder(title: String, description: String, date: Date, success: @escaping () -> Void, failure: @escaping (String) -> Void)
}
