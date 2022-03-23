//
//  ReminderDataManager.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation

public class ReminderDataManager {
    var database: ReminderDatabaseContract
    
    public init(database: ReminderDatabaseContract) {
        self.database = database
    }
}
extension ReminderDataManager: AddReminderDataManagerContract {
    
    public func addReminder(username: String, reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (AddReminderError) -> Void) {
        database.addReminder(username: username, reminder: reminder, success: {
            [weak self]
            (reminder) in
            self?.addReminderSuccess(reminder: reminder, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.addReminderFailure(message: message, callback: failure)
        })
    }
    
    private func addReminderSuccess(reminder: Reminder, callback: (Reminder) -> Void) {
        callback(reminder)
    }
    
    private func addReminderFailure(message: String, callback: (AddReminderError) -> Void) {
        if message == "Addition Failed" {
            let error = AddReminderError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = AddReminderError(status: .networkUnavailable)
            callback(error)
        }
    }
}
 
extension ReminderDataManager: GetReminderListDataManagerContract {
    public func getReminderList(username: String, success: ([Reminder]) -> Void, failure: (GetReminderListError) -> Void) {
        database.getReminderList(username: username, success: {
            [weak self]
            (reminders) in
            self?.getReminderListSuccess(reminders: reminders, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.getReminderListFailure(message: message, callback: failure)
        })
    }
    
    private func getReminderListSuccess(reminders: [Reminder], callback: ([Reminder]) -> Void) {
        callback(reminders)
    }
    
    private func getReminderListFailure(message: String, callback: (GetReminderListError) -> Void) {
        if message == "No Data" {
            let error = GetReminderListError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = GetReminderListError(status: .networkUnavailable)
            callback(error)
        }
    }
}
 
extension ReminderDataManager: UpdateReminderDataManagerContract {
    public func updateReminder(username: String, reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (UpdateReminderError) -> Void) {
        database.updateReminder(username: username, reminder: reminder, success: {
            [weak self]
            (reminder) in
            self?.updateReminderSuccess(reminder: reminder, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.updateReminderFailure(message: message, callback: failure)
        })
    }
    
    private func updateReminderSuccess(reminder: Reminder, callback: (Reminder) -> Void) {
        callback(reminder)
    }
    
    private func updateReminderFailure(message: String, callback: (UpdateReminderError) -> Void) {
        if message == "Updation Failed" {
            let error = UpdateReminderError(status: .unknownError)
            callback(error)
        } else if message == "Invalid Data" {
            let error = UpdateReminderError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = UpdateReminderError(status: .networkUnavailable)
            callback(error)
        }
    }
}
 
extension ReminderDataManager: DeleteReminderDataManagerContract {
    public func deleteReminder(username: String, reminder: Reminder, success: @escaping (Reminder) -> Void, failure: @escaping (DeleteReminderError) -> Void) {
        database.deleteReminder(username: username, reminder: reminder, success: {
            [weak self]
            (reminder) in
            self?.deleteReminderSuccess(reminder: reminder, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.deleteReminderFailure(message: message, callback: failure)
        })
    }
    
    private func deleteReminderSuccess(reminder: Reminder, callback: (Reminder) -> Void) {
        callback(reminder)
    }
    
    private func deleteReminderFailure(message: String, callback: (DeleteReminderError) -> Void) {
        if message == "Deletion Failed" {
            let error = DeleteReminderError(status: .unknownError)
            callback(error)
        } else if message == "Invalid Data" {
            let error = DeleteReminderError(status: .unknownError)
            callback(error)
        } else if message == "No Database Connection" {
            let error = DeleteReminderError(status: .networkUnavailable)
            callback(error)
        }
    }
}

extension ReminderDataManager: GetAllUsersDataManagerContract {
    public func getAllUsers(success: @escaping ([User]) -> Void, failure: @escaping (GetAllUsersError) -> Void) {
        database.getAllUsers(success: {
            [weak self]
            (users) in
            self?.getAllUsersSuccess(users: users, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.getAllUsersFailure(message: message, callback: failure)
        })
    }
    
    private func getAllUsersSuccess(users: [User], callback: ([User]) -> Void) {
        callback(users)
    }
    
    private func getAllUsersFailure(message: String, callback: (GetAllUsersError) -> Void) {
        if message == "No Database Connection" {
            let error = GetAllUsersError(status: .networkUnavailable)
            callback(error)
        } else if message == "No User Found" {
            let error = GetAllUsersError(status: .unknownError)
            callback(error)
        }
    }
}
extension ReminderDataManager: CreateUserDataManagerContract {
    public func createUser(username: String, password: String, imageURL: URL?, success: @escaping (String) -> Void, failure: @escaping (CreateUserError) -> Void) {
        database.createUser(username: username, password: password, imageURL: imageURL, success: {
            [weak self]
            (username) in
            self?.createUserSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.createUserFailure(message: message, callback: failure)
        })
    }
    
    private func createUserSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func createUserFailure(message: String, callback: (CreateUserError) -> Void) {
        if message == "No Database Connection" {
            let error = CreateUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "Creation Failed" {
            let error = CreateUserError(status: .unknownError)
            callback(error)
        } else if message == "User Already Exists" {
            let error = CreateUserError(status: .unknownError)
            callback(error)
        }
    }
}
extension ReminderDataManager: IsCorrectPasswordDataManagerContract {
    public func isCorrectPassword(username: String, password: String, success: @escaping (String) -> Void, failure: @escaping (IsCorrectPasswordError) -> Void) {
        database.isCorrectPassword(username: username, password: password, success: {
            [weak self]
            (username) in
            self?.isCorrectPasswordSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.isCorrectPasswordFailure(message: message, callback: failure)
        })
    }
    
    private func isCorrectPasswordSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func isCorrectPasswordFailure(message: String, callback: (IsCorrectPasswordError) -> Void) {
        if message == "No Database Connection" {
            let error = IsCorrectPasswordError(status: .networkUnavailable)
            callback(error)
        } else if message == "User Name Not Found" {
            let error = IsCorrectPasswordError(status: .authenticationFailure)
            callback(error)
        } else if message == "Password Incorrect" {
            let error = IsCorrectPasswordError(status: .authenticationFailure)
            callback(error)
        }
    }
}
extension ReminderDataManager: RemoveUserDataManagerContract {
    public func removeUser(username: String, success: @escaping (String) -> Void, failure: @escaping (RemoveUserError) -> Void) {
        database.removeUser(username: username, success: {
            [weak self]
            (username) in
            self?.removeUserSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.removeUserFailure(message: message, callback: failure)
        })
    }
    
    private func removeUserSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func removeUserFailure(message: String, callback: (RemoveUserError) -> Void) {
        if message == "No Database Connection" {
            let error = RemoveUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "Deletion Failed" {
            let error = RemoveUserError(status: .unknownError)
            callback(error)
        }
    }
}
extension ReminderDataManager: ChangePasswordDataManagerContract {
    
    public func changePassword(username: String, password: String, success: @escaping (String) -> Void, failure: @escaping (ChangePasswordError) -> Void) {
        database.changePassword(username: username, password: password, success: {
            [weak self]
            (username) in
            self?.changePasswordSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.changePasswordFailure(message: message, callback: failure)
        })
    }
    
    private func changePasswordSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func changePasswordFailure(message: String, callback: (ChangePasswordError) -> Void) {
        if message == "No Database Connection" {
            let error = ChangePasswordError(status: .networkUnavailable)
            callback(error)
        } else if message == "Updation Failed" {
            let error = ChangePasswordError(status: .unknownError)
            callback(error)
        }
    }
}
extension ReminderDataManager: DoesUserExistsDataManagerContract {
    public func doesUserExists(username: String, success: @escaping (String) -> Void, failure: @escaping (DoesUserExistsError) -> Void) {
        database.doesUserExists(username: username, success: {
            [weak self]
            (username) in
            self?.doesUserExistsSuccess(username: username, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.doesUserExistsFailure(message: message, callback: failure)
        })
    }
    
    private func doesUserExistsSuccess(username: String, callback: (String) -> Void) {
        callback(username)
    }
    
    private func doesUserExistsFailure(message: String, callback: (DoesUserExistsError) -> Void) {
        if message == "No Database Connection" {
            let error = DoesUserExistsError(status: .networkUnavailable)
            callback(error)
        } else if message == "User Does Not Exists" {
            let error = DoesUserExistsError(status: .unknownError)
            callback(error)
        }
    }
}

extension ReminderDataManager: GetLastLoggedInUserDataManagerContract {
    public func getLastLoggedInUser(success: @escaping (User) -> Void, failure: @escaping (GetLastLoggedInUserError) -> Void) {
        database.getLastLoggedInUser(success: {
            [weak self]
            (user) in
            self?.getLastLoggedInUserSuccess(user: user, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.getLastLoggedInUserFailure(message: message, callback: failure)
        })
    }
    
    private func getLastLoggedInUserSuccess(user: User, callback: (User) -> Void) {
        callback(user)
    }
    
    private func getLastLoggedInUserFailure(message: String, callback: (GetLastLoggedInUserError) -> Void) {
        if message == "No Database Connection" {
            let error = GetLastLoggedInUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "No User Found" {
            let error = GetLastLoggedInUserError(status: .unknownError)
            callback(error)
        }
    }
}

extension ReminderDataManager: SetLastLoggedInUserDataManagerContract {
    public func setLastLoggedInUser(user: User, success: @escaping (User) -> Void, failure: @escaping (SetLastLoggedInUserError) -> Void) {
        database.setLastLoggedInUser(user: user, success: {
            [weak self]
            (user) in
            self?.success(user: user, callback: success)
        }, failure: {
            [weak self]
            (message) in
            self?.failure(message: message, callback: failure)
        })
    }
    
    private func success(user: User, callback: (User) -> Void) {
        callback(user)
    }
    
    private func failure(message: String, callback: (SetLastLoggedInUserError) -> Void) {
        if message == "No Database Connection" {
            let error = SetLastLoggedInUserError(status: .networkUnavailable)
            callback(error)
        } else if message == "Updation Failed" {
            let error = SetLastLoggedInUserError(status: .unknownError)
            callback(error)
        }
    }
}
