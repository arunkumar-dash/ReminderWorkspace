//
//  DashboardViewControllerContract.swift
//  Reminder
//
//  Created by Arun Kumar on 17/03/22.
//

import Foundation
import AppKit
import ReminderBackEnd

protocol DashboardViewControllerContract: NSViewController {
    func getLastLoggedInUserImageURL(success: @escaping (URL?) -> Void, failure: @escaping (String) -> Void)
    func changeViewToLogin()
    func addReminder(title: String, description: String, date: Date, repeatPattern: RepeatPattern, success: @escaping () -> Void, failure: @escaping (String) -> Void)
    func changeViewToEditReminder(reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (String) -> Void)
}
