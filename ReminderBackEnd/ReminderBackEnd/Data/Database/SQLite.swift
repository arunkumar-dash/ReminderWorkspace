//
//  SQLite.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 16/03/22.
//

import Foundation
import SQLite3

/// Errors to handle SQLite3 error codes
enum SQLiteError: Error {
    case connectionError(message: String)
    case preparationError(message: String)
    case stepError(message: String)
    case bindError(message: String)
    case tableCreationFailure(message: String)
}

/// Localized Description for `SQLiteError`
extension SQLiteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .connectionError(message: let message):
            return "Connection Error: \(message)"
        case .preparationError(message: let message):
            return "Preparation Error: \(message)"
        case .stepError(message: let message):
            return "Step Error: \(message)"
        case .bindError(message: let message):
            return "Bind Error: \(message)"
        case .tableCreationFailure(message: let message):
            return "Table Creation Failure: \(message)"
        }
    }
}

/// A wrapper over the SQLite3 framework
class SQLite {
    /// The C pointer which is used to perform all database operations
    private let dbPointer: OpaquePointer?
    private static let noErrorMessage = "No error message provided from sqlite."
    /// Initialiser is private because the user should instantiate only using static functions
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        /// Clearing the memory referenced by the pointer to avoid memory leaks
        sqlite3_close(dbPointer)
    }
    /// Connects the database to the file with extension .sqlite and returns an SQLite instance
    /// - Parameter path: The absolute path of the file with .sqlite extension
    /// - Returns: An SQLite instance initiated with the database
    static func connect(path: String) throws -> SQLite {
        var db: OpaquePointer?
        /// Opening the connection to database, `SQLITE_OK` is a success code
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Connection success")
            return SQLite(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    /// Closing the database incase of failure
                    sqlite3_close(db)
                }
            }
            /// Handling errors
            if let errorPointer = sqlite3_errmsg(db) {
                let errorMessage = String(cString: errorPointer)
                throw SQLiteError.connectionError(message: errorMessage)
            } else {
                throw SQLiteError.connectionError(message: Self.noErrorMessage)
            }
        }
    }
    /// A property to hold the most recent error message
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return Self.noErrorMessage
        }
    }
}

extension SQLite {
    /// Prepares the SQL command and returns the pointer to the compiled command
    /// - Parameter sql: The SQL command as a `String`
    /// - Returns: An `OpaquePointer` which references the compiled SQL statement
    /// - Throws:
    ///  - preparationError: When `sqlite3_prepare_v2()` returns a constant other than `SQLITE_OK`
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.preparationError(message: errorMessage)
        }
        return statement
    }
}

extension SQLite {
    /// Creates a table
    /// - Parameter createStatement: The SQL command to create the table
    func createTable(createStatement: String) throws {
        
        do {

            let createTableStatement = try prepareStatement(sql: createStatement)
            
            defer {
                sqlite3_finalize(createTableStatement)
            }
            
            guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
                throw SQLiteError.stepError(message: errorMessage)
            }
        } catch let error {
            let errorMessage = error.localizedDescription
            throw SQLiteError.tableCreationFailure(message: errorMessage)
        }
    }
}
