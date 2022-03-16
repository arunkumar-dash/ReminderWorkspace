//
//  GetReminderListDataManagerContract.swift
//  Reminder
//
//  Created by Arun Kumar on 04/03/22.
//

import Foundation

public protocol GetReminderListDataManagerContract {
    func getReminderList(username: String, success: @escaping ([Reminder]) -> Void, failure: @escaping (GetReminderListError) -> Void)
}
