//
//  ReminderDatabase.swift
//  ReminderBackEnd
//
//  Created by Arun Kumar on 22/03/22.
//

import Foundation
import SQLite3

/// The formats available to be encoded
enum EncodingFormat {
    case json
}

/// Errors which can be thrown while Encoding/Decoding
enum CodingError: Error {
    case invalidEncodingFormat
    case invalidObject
    case invalidData
    case invalidDecodingFormat
}

extension CodingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidEncodingFormat:
            return "Invalid Encoding Format"
        case .invalidObject:
            return "Invalid Object"
        case .invalidData:
            return "Invalid Data"
        case .invalidDecodingFormat:
            return "Invalid Decoding Format"
        }
    }
}

extension Encodable {
    /// Encodes the type with respect to the Encoding format
    /// - Parameter type: The type to which the object should be encoded
    /// - Returns: The encoded `Data`
    func encode(as type: EncodingFormat) throws -> Data {
        if type == .json {
            do {
                let data = try JSONEncoder().encode(self)
                return data
            } catch EncodingError.invalidValue(_, let context) {
                print(context.debugDescription)
                throw CodingError.invalidObject
            }
        } else {
            throw CodingError.invalidEncodingFormat
        }
    }
}

extension Data {
    /// Decodes the `Data` from the `format` specified to the `type` specified in parameters
    /// - Parameter type: The `Type` to which the `Data` should be decoded
    /// - Returns: The instance of the type specified in parameters
    func decode<Type: Decodable>(_ type: Type.Type, format: EncodingFormat) throws -> Type {
        if format == .json {
            do {
                let object = try JSONDecoder().decode(type, from: self)
                return object
            } catch DecodingError.dataCorrupted(let context) {
                print(context.debugDescription)
                throw CodingError.invalidData
            }
        } else {
            throw CodingError.invalidDecodingFormat
        }
    }
}


class ReminderDatabase {
    private init() {
        if connect() == false {
            print("Database Connection Failed")
        }
    }
    
    
    static var shared: ReminderDatabase = ReminderDatabase()
    let folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".ReminderAppDatabase")
    let imagesFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".ReminderAppDatabase").appendingPathComponent(".Images")
    let databasePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(".ReminderAppDatabase").appendingPathComponent("Reminder.sqlite")
    
    private func connect() -> Bool {
        
        // check folderPath exists, no -> create folder
        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print("Failed to create directory while connecting to database")
            print(error)
            return false
        }
        
        // check imagesPath exists, no -> create folder
        do {
            try FileManager.default.createDirectory(at: imagesFolderPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print("Failed to create images directory")
            print(error)
            return false
        }
        
        // check sqlite file exists, no -> create
        // check tables(User, Reminder, UserConstant, Constant) exists, no -> create
        return connectDatabase() && true
    }
    
    var database: SQLite?
    
    private func connectDatabase() -> Bool {
        
        return createUserTable() && createReminderTable() && createUserConstantTable() && createConstantTable()
    }
    
    private func createUserTable() -> Bool {
        
        do {
            /// Connecting to the SQLite file
            if database == nil {
                database = try SQLite.connect(path: databasePath.relativePath)
            }
            
            let createUserStatement = """
            CREATE TABLE User (
            username VARCHAR PRIMARY KEY NOT NULL,
            password VARCHAR NOT NULL,
            image VARCHAR
            );
            """

            if let database = database {
                /// Creating the User table
                
                try database.createTable(createStatement: createUserStatement)
                print("User table created successfully")
                
                return true
            } else {
                print("No database connected -- unexpected error")
                return false
            }
        } catch SQLiteError.tableCreationFailure(message: _) {
            print("User table already exists")
            return true
        } catch SQLiteError.connectionError(message: let error) {
            print("SQL connection failed")
            print(error)
            return false
        } catch SQLiteError.stepError(message: let error) {
            print("User table creation failed")
            print(error)
            return true
        } catch SQLiteError.preparationError(message: let error) {
            print("Preparation error while creating database")
            print(error)
            return false
        } catch let error {
            print("Unexpected error occured while initiating database")
            print(error)
            return false
        }
    }
    
    private func createReminderTable() -> Bool {
        
        do {
            /// Connecting to the SQLite file
            if database == nil {
                database = try SQLite.connect(path: databasePath.relativePath)
            }
            
            let createReminderStatement = """
            CREATE TABLE Reminder (
            username VARCHAR NOT NULL,
            id INT NOT NULL,
            base64_encoded_json_string VARCHAR,
            PRIMARY KEY (username, id),
            FOREIGN KEY (username) REFERENCES User(username)
            );
            """
            
            if let database = database {
                /// Creating the Reminder table
                
                try database.createTable(createStatement: createReminderStatement)
                print("Reminder table created successfully")
                
                return true
            } else {
                print("No database connected -- unexpected error")
                return false
            }
        } catch SQLiteError.tableCreationFailure(message: _) {
            print("Reminder table already exists")
            return true
        } catch SQLiteError.connectionError(message: let error) {
            print("SQL connection failed")
            print(error)
            return false
        } catch SQLiteError.stepError(message: let error) {
            print("Reminder table creation failed")
            print(error)
            return true
        } catch SQLiteError.preparationError(message: let error) {
            print("Preparation error while creating database")
            print(error)
            return false
        } catch let error {
            print("Unexpected error occured while initiating database")
            print(error)
            return false
        }
    }
    
    
    private func createUserConstantTable() -> Bool {
        
        do {
            /// Connecting to the SQLite file
            if database == nil {
                database = try SQLite.connect(path: databasePath.relativePath)
            }
            
            let createUserConstantStatement = """
            CREATE TABLE UserConstant (
            username VARCHAR NOT NULL,
            key VARCHAR NOT NULL,
            value VARCHAR,
            PRIMARY KEY (username, key),
            FOREIGN KEY (username) REFERENCES User(username)
            );
            """
            
            if let database = database {
                /// Creating the UserConstant table
                
                try database.createTable(createStatement: createUserConstantStatement)
                print("UserConstant table created successfully")
                
                return true
            } else {
                print("No database connected -- unexpected error")
                return false
            }
        } catch SQLiteError.tableCreationFailure(message: _) {
            print("UserConstant table already exists")
            return true
        } catch SQLiteError.connectionError(message: let error) {
            print("SQL connection failed")
            print(error)
            return false
        } catch SQLiteError.stepError(message: let error) {
            print("UserConstant table creation failed")
            print(error)
            return true
        } catch SQLiteError.preparationError(message: let error) {
            print("Preparation error while creating database")
            print(error)
            return false
        } catch let error {
            print("Unexpected error occured while initiating database")
            print(error)
            return false
        }
    }
    
    private func createConstantTable() -> Bool {
        
        do {
            /// Connecting to the SQLite file
            if database == nil {
                database = try SQLite.connect(path: databasePath.relativePath)
            }
            
            let createConstantStatement = """
            CREATE TABLE Constant (
            key VARCHAR PRIMARY KEY NOT NULL,
            value VARCHAR
            );
            """
            
            if let database = database {
                /// Creating the UserConstant table
                
                try database.createTable(createStatement: createConstantStatement)
                print("Constant table created successfully")
                
                return true
            } else {
                print("No database connected -- unexpected error")
                return false
            }
        } catch SQLiteError.tableCreationFailure(message: _) {
            print("Constant table already exists")
            return true
        } catch SQLiteError.connectionError(message: let error) {
            print("SQL connection failed")
            print(error)
            return false
        } catch SQLiteError.stepError(message: let error) {
            print("Constant table creation failed")
            print(error)
            return true
        } catch SQLiteError.preparationError(message: let error) {
            print("Preparation error while creating database")
            print(error)
            return false
        } catch let error {
            print("Unexpected error occured while initiating database")
            print(error)
            return false
        }
    }
    
    func createUser(username: String, password: String, imageURL: URL?) -> Bool {
        
        var result = true
        let insertStatement: String = """
        INSERT INTO User(username, password, image)
        VALUES ('\(username)', ?, ?);
        """
        do {
            if let database = database {
                let insertSql = try database.prepareStatement(sql: insertStatement)
                defer {
                    database.finalize(insertSql)
                }
                
                
                guard let encodedPassword = password.data(using: .utf8)?.base64EncodedString() else {
                    print("Error in encoding to base64")
                    return false
                }
                let passwordString = encodedPassword as NSString
    
                do {
                    try FileManager.default.createDirectory(at: imagesFolderPath, withIntermediateDirectories: true, attributes: nil)
                } catch let error {
                    print("Failed to create directory while inserting user image to database")
                    print(error)
                    return false
                }
                var localImageURL: URL? = nil
                if let imageURL = imageURL {
                    let destinationURL = imagesFolderPath.appendingPathComponent(imageURL.lastPathComponent)
                    do {
                        try FileManager.default.copyItem(at: imageURL, to: destinationURL)
                    } catch let error {
                        print("Some error occured while copying image to local folder.")
                        print(error)
                    }
                    localImageURL = destinationURL
                }
                let imageString = (localImageURL?.relativePath) as NSString?
                guard database.bindText(insertSql, 1, passwordString.utf8String) &&
                         database.bindText(insertSql, 2, imageString?.utf8String)
                else {
                    throw SQLiteError.bindError(message: database.errorMessage)
                }
                /// Executing the query
                guard database.step(insertSql) == SQLITE_DONE else {
                    throw SQLiteError.stepError(message: database.errorMessage)
                }
                
                print("Successfully inserted row.")
                
                
                createDefaultConstants(for: username)
                
                
                return result
            } else {
                print("No database connection")
                result = false
                return result
            }
        } catch SQLiteError.stepError(message: let error) {
            print("Cannot create entry in User table")
            print(error)
            return false
        } catch SQLiteError.bindError(message: let error) {
            print("Cannot create entry in User table")
            print(error)
            return result
        } catch SQLiteError.preparationError(message: let error) {
            print("Cannot create entry in User table")
            print(error)
            return false
        } catch let error {
            print("Cannot create entry in User table")
            print(error)
            return false
        }
    }
    
    func getPassword(forUsername username: String) -> String? {
        
        let selectStatement = """
        SELECT password FROM User WHERE username = '\(username)';
        """
        do {
            if let database = database {
                /// Preparing the query
                let selectSql = try database.prepareStatement(sql: selectStatement)
                defer {
                    database.finalize(selectSql)
                }
                
                /// Executing the query
                guard database.step(selectSql) == SQLITE_ROW else {
                    print("Failure in retrieving from User table, no rows found")
                    print(database.errorMessage)
                    return nil
                }
                guard let result = database.columnText(selectSql, 0) else {
                    print("Failure in retrieving from User table, no data found")
                    print(database.errorMessage)
                    return nil
                }
                /// Converting result of cString to the object after decoding from base64
                let encodedPassword = String(cString: result)
                print("Successfully retrieved row.")
                guard let data = Data(base64Encoded: encodedPassword) else {
                    print("Error in decoding from base64")
                    return nil
                }
                guard let password = String(data: data, encoding: .utf8) else {
                    print("Error in decoding from data")
                    return nil
                }
                return password
            } else {
                print("No database connection")
                return nil
            }
        } catch let error {
            print("Error while retrieving row from User table")
            print(error)
            return nil
        }
    }
    
    func doesUserExists(username: String) -> Bool {
        
        
        let selectStatement = """
        SELECT password FROM User WHERE username = '\(username)';
        """
        do {
            if let database = database {
                /// Preparing the query
                let selectSql = try database.prepareStatement(sql: selectStatement)
                defer {
                    database.finalize(selectSql)
                }
                
                /// Executing the query
                guard database.step(selectSql) == SQLITE_ROW else {
                    print("Failure in retrieving from User table, no rows found")
                    print(database.errorMessage)
                    return false
                }
                if let _ = database.columnText(selectSql, 0) {
                    print("Successfully retrieved row.")
                    return true
                } else {
                    print("Failure in retrieving from User table, no data found")
                    print(database.errorMessage)
                    return false
                }
            } else {
                print("No database connection")
                return false
            }
        } catch let error {
            print("Error while retrieving row from User table")
            print(error)
            return false
        }
    }
    
    func getAllUsers() -> [User] {
        
        let selectAllStatement: String =
        """
        SELECT * FROM User;
        """
        var userList: [User] = []
        do {
            if let database = database {
                /// Preparing the query
                let selectSql = try database.prepareStatement(sql: selectAllStatement)
                defer {
                    database.finalize(selectSql)
                }
                /// Executing the query
                while database.step(selectSql) == SQLITE_ROW {
                    /// Retrieving the data of the first row from the result
                    guard let username = database.columnText(selectSql, 0) else {
                        continue
                    }
                    guard let encodedCStringPassword = database.columnText(selectSql, 1) else {
                        continue
                    }
                    let encodedPassword = String(cString: encodedCStringPassword)
                    guard let data = Data(base64Encoded: encodedPassword) else {
                        continue
                    }
                    guard let password = String(data: data, encoding: .utf8) else {
                        continue
                    }
                    var imageURL: URL? = nil
                    if let optionalURL = database.columnText(selectSql, 2) {
                        imageURL = URL(string: String(cString: optionalURL))
                    }
                    let user = User(username: String(cString: username), password: password, imageURL: imageURL)
                    userList.append(user)
                }
                return userList
            } else {
                print("No database connection")
                return []
            }
        } catch let error {
            print("Error while retrieving row from User table")
            print(error)
            return []
        }
    }
    
    func editUser(password: String, for username: String) -> Bool {
        
        var updateStatement: String {
            """
            UPDATE User SET password = ?
            WHERE username = '\(username)';
            """
        }
        do {
            if let database = database {
                let updateSql = try database.prepareStatement(sql: updateStatement)
                defer {
                    database.finalize(updateSql)
                }
                
                guard let encodedPassword = password.data(using: .utf8)?.base64EncodedString() else {
                    print("Error in encoding to base64")
                    return false
                }
                let passwordString = encodedPassword as NSString
                
                guard database.bindText(updateSql, 1, passwordString.utf8String)
                else {
                    throw SQLiteError.bindError(message: database.errorMessage)
                }
                
                guard database.step(updateSql) == SQLITE_DONE else {
                    throw SQLiteError.stepError(message: database.errorMessage)
                }
                print("Successfully updated row.")
                return true
            } else {
                print("No database connection")
                return false
            }
        } catch SQLiteError.stepError(message: let error) {
            print("Failed to update a row in User table")
            print(error)
            return false
        } catch let error {
            print("Failed to update a row in User table")
            print(error)
            return false
        }
    }
    
    func removeUser(username: String) -> Bool {
        
        let deleteStatement: String = """
        DELETE FROM User
        WHERE username = '\(username)';
        """
        do {
            if let database = database {
                let deleteSql = try database.prepareStatement(sql: deleteStatement)
                defer {
                    database.finalize(deleteSql)
                }
                
                
                guard database.step(deleteSql) == SQLITE_DONE else {
                    throw SQLiteError.stepError(message: database.errorMessage)
                }
                print("Successfully deleted row.")
                return true
            } else {
                print("No database connection")
                return false
            }
        } catch SQLiteError.stepError(message: let error) {
            print("Failed to delete a row in User table")
            print(error)
            return false
        } catch let error {
            print("Failed to delete a row in User table")
            print(error)
            return false
        }
    }
    
    private func getLastRowID(for user: String) -> Int32? {
        
        var query: String {
            """
            SELECT MAX(id) FROM Reminder WHERE username = '\(user)';
            """
        }
        do {
            if let database = self.database {
                /// Preparing the query
                let sql = try database.prepareStatement(sql: query)
                defer {
                    database.finalize(sql)
                }
                /// Executing the query
                guard database.step(sql) == SQLITE_ROW else {
                    return nil
                }
                /// Retrieving the data of the first row from the result
                guard let result = database.columnText(sql, 0) else {
                    return nil
                }
                
                return Int32(String(cString: result))
            } else {
                print("No database connection")
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func createReminder(for username: String, reminder: Reminder) -> Bool {
        
        let idGenerator: Int32
        if let lastRowID = getLastRowID(for: username) {
            idGenerator = lastRowID + 1
        } else {
            idGenerator = 1
        }
        let insertStatement: String =
        """
        INSERT INTO Reminder(username, id, base64_encoded_json_string)
        VALUES ('\(username)', ?, ?);
        """
        do {
            var result = true
            if let database = database {
                let insertSql = try database.prepareStatement(sql: insertStatement)
                defer {
                    database.finalize(insertSql)
                }
                /// Assign id
                var mutableElement = reminder
                mutableElement.id = idGenerator
                
                /// Object encoded as string
                let string = try mutableElement.encode(as: .json).base64EncodedString() as NSString
                /// Binding the `id` and the `data`
                guard database.bindInt(insertSql, 1, idGenerator) &&
                        database.bindText(insertSql, 2, string.utf8String)
                else {
                    throw SQLiteError.bindError(message: database.errorMessage)
                }
                /// Executing the query
                guard database.step(insertSql) == SQLITE_DONE else {
                    throw SQLiteError.stepError(message: database.errorMessage)
                }
                
                print("Successfully inserted row.")
                return result
            } else {
                print("No database connection")
                result = false
                return result
            }
        } catch SQLiteError.stepError(message: let error) {
            print("Cannot create entry in Reminder table")
            print(error)
            return false
        } catch SQLiteError.bindError(message: let error) {
            print("Cannot create entry in Reminder table")
            print(error)
            return false
        } catch SQLiteError.preparationError(message: let error) {
            print("Cannot create entry in Reminder table")
            print(error)
            return false
        } catch let error {
            print("Cannot create entry in Reminder table")
            print(error)
            return false
        }
    }
    
    func getAllReminders(for username: String) -> [Reminder?] {
        
        let selectAllStatement: String =
        """
        SELECT * FROM Reminder WHERE username = '\(username)';
        """
        var reminderList: [Reminder?] = []
        do {
            if let database = database {
                /// Preparing the query
                let selectSql = try database.prepareStatement(sql: selectAllStatement)
                defer {
                    database.finalize(selectSql)
                }
                /// Executing the query
                while database.step(selectSql) == SQLITE_ROW {
                    /// Retrieving the data of the first row from the result
                    guard let result = database.columnText(selectSql, 2) else {
                        continue
                    }
                    /// Converting result of cString to the object after decoding from base64
                    let object = try? Data(base64Encoded: String(cString: result))?.decode(Reminder.self, format: .json)
                    reminderList.append(object)
                }
                return reminderList
            } else {
                print("No database connection")
                return []
            }
        } catch let error {
            print("Error while retrieving row from Reminder table")
            print(error)
            return []
        }
    }
    
    func updateReminder(username: String, id: Int32, element: Reminder) -> Bool {
        
        do {
            let mutableElement = element
            
            /// The instance is converted to json and encoded in base64 encoding
            let string = try mutableElement.encode(as: .json).base64EncodedString()
            
            let updateStatement: String = """
                UPDATE Reminder SET base64_encoded_json_string = '\(string)'
                WHERE id = \(id) AND username = '\(username)';
                """
            if let database = database {
                let updateSql = try database.prepareStatement(sql: updateStatement)
                defer {
                    database.finalize(updateSql)
                }
                guard database.step(updateSql) == SQLITE_DONE else {
                    print("Failure in updating Reminder table")
                    print(database.errorMessage)
                    return false
                }
                print("Successfully updated row.")
                return true
            } else {
                print("No database connection")
                return false
            }
            
        } catch let error {
            print("Failed to update a row in Reminder table")
            print(error)
            return false
        }
    }
    
    func deleteReminder(for username: String, id: Int32) -> Bool {
        
        do {
            let deleteStatement: String = """
                DELETE FROM Reminder
                WHERE id = \(id) and username = '\(username)';
                """
            if let database = database {
                let deleteSql = try database.prepareStatement(sql: deleteStatement)
                defer {
                    database.finalize(deleteSql)
                }
                guard database.step(deleteSql) == SQLITE_DONE else {
                    print("Failure in deleting from Reminder table")
                    print(database.errorMessage)
                    return false
                }
                print("Successfully deleted row.")
                return true
            } else {
                print("No database connection")
                return false
            }
        } catch let error {
            print("Failed to delete a row in Reminder table")
            print(error)
            return false
        }
    }
    
    func getReminder(for username: String, id: Int32) -> Reminder? {
        
        
        let selectStatement: String =
        """
        SELECT * FROM Reminder WHERE id = \(id) and username = '\(username)';
        """
        do {
            if let database = database {
                /// Preparing the query
                let selectSql = try database.prepareStatement(sql: selectStatement)
                defer {
                    database.finalize(selectSql)
                }
                /// Executing the query
                guard database.step(selectSql) == SQLITE_ROW else {
                    print("Failure in retrieving from Reminder table")
                    print(database.errorMessage)
                    return nil
                }
                /// Retrieving the data of the first row from the result
                guard let result = database.columnText(selectSql, 2) else {
                    print("Failure in retrieving from Reminder table, no rows found")
                    print(database.errorMessage)
                    return nil
                }
                /// Converting result of cString to the object after decoding from base64
                let object = try Data(base64Encoded: String(cString: result))?.decode(Reminder.self, format: .json)
                print("Successfully retrieved row.")
                return object
            } else {
                print("No database connection")
                return nil
            }
        } catch let error {
            print("Error while retrieving row from Reminder table")
            print(error)
            return nil
        }
    }
    
    func getUserConstant(for username: String, key: String) -> String? {
        
        
        let selectStatement =
        """
        SELECT value FROM UserConstant
        WHERE username = '\(username)' and key = '\(key)';
        """
        do {
            if let database = database {
                /// Preparing the query
                let selectSql = try database.prepareStatement(sql: selectStatement)
                defer {
                    database.finalize(selectSql)
                }
                /// Executing the query
                guard database.step(selectSql) == SQLITE_ROW else {
                    print("Failure in retrieving from UserConstant table")
                    print(database.errorMessage)
                    return nil
                }
                /// Retrieving the data of the first row from the result
                guard let result = database.columnText(selectSql, 0) else {
                    print("Failure in retrieving from UserConstant table")
                    print(database.errorMessage)
                    return nil
                }
                /// Converting result of cString to String
                let value = String(cString: result)
                print("Successfully retrieved row.")
                return value
            } else {
                print("No database connection")
                return nil
            }
        } catch let error {
            print("Error while retrieving row from UserConstant table")
            print(error)
            return nil
        }
    }
    
    func getConstant(for key: String) -> String? {
        
        
        let selectStatement =
        """
        SELECT value FROM Constant
        WHERE key = '\(key)';
        """
        do {
            if let database = database {
                /// Preparing the query
                let selectSql = try database.prepareStatement(sql: selectStatement)
                defer {
                    database.finalize(selectSql)
                }
                /// Executing the query
                guard database.step(selectSql) == SQLITE_ROW else {
                    print("Failure in retrieving from Constant table")
                    print(database.errorMessage)
                    return nil
                }
                /// Retrieving the data of the first row from the result
                guard let result = database.columnText(selectSql, 0) else {
                    print("Failure in retrieving from Constant table")
                    print(database.errorMessage)
                    return nil
                }
                /// Converting result of cString to String
                let value = String(cString: result)
                print("Successfully retrieved row.")
                return value
            } else {
                print("No database connection")
                return nil
            }
        } catch let error {
            print("Error while retrieving row from Constant table")
            print(error)
            return nil
        }
    }
    
    func createConstant(for key: String, value: String) -> Bool {
        
        let insertStatement: String =
        """
        INSERT INTO Constant(key, value)
        VALUES ('\(key)', '\(value)');
        """
        do {
            if let database = database {
                let insertSql = try database.prepareStatement(sql: insertStatement)
                defer {
                    database.finalize(insertSql)
                }
                /// Executing the query
                guard database.step(insertSql) == SQLITE_DONE else {
                    throw SQLiteError.stepError(message: database.errorMessage)
                }
                
                print("Successfully inserted row in Constant table")
                return true
            } else {
                print("No database connection")
                return false
            }
        } catch SQLiteError.stepError(message: let error) {
            print("Cannot create entry in Constant table")
            print(error)
            return false
        } catch SQLiteError.preparationError(message: let error) {
            print("Cannot create entry in Constant table")
            print(error)
            return false
        } catch let error {
            print("Cannot create entry in Constant table")
            print(error)
            return false
        }
    }
    
    func updateConstant(for key: String, value: String) -> Bool {
        
        guard getConstant(for: key) != nil else {
            return createConstant(for: key, value: value)
        }
        
        do {
            
            let updateStatement: String = """
                UPDATE Constant SET value = '\(value)'
                WHERE key = '\(key)';
                """
            if let database = database {
                let updateSql = try database.prepareStatement(sql: updateStatement)
                defer {
                    database.finalize(updateSql)
                }
                guard database.step(updateSql) == SQLITE_DONE else {
                    print("Failure in updating Constant table")
                    print(database.errorMessage)
                    return false
                }
                print("Successfully updated row.")
                return true
            } else {
                print("No database connection")
                return false
            }
        } catch let error {
            print("Failed to update a row in Constant table")
            print(error)
            return false
        }
    }
    
    func getLastLoggedInUser() -> User? {
        
        guard let lastLoggedInUserEncodedString = getConstant(for: "lastLoggedInUser") else { return nil }
        do {
            let user = try lastLoggedInUserEncodedString.data(using: .utf8)?.decode(User.self, format: .json)
            return user
        } catch let error {
            print("Cannot decode User from database")
            print(error)
            return nil
        }
    }
    
    func setLastLoggedInUser(user: User) -> Bool {
        
        
        do {
            let lastLoggedInUserEncodedData = try user.encode(as: EncodingFormat.json)
            guard let lastLoggedInUserEncodedString = String(data: lastLoggedInUserEncodedData, encoding: .utf8) else {
                return false
            }
            
            return updateConstant(for: "lastLoggedInUser", value: lastLoggedInUserEncodedString)
        } catch let error {
            print("Cannot encode User while updating to database")
            print(error)
            return false
        }
    }
    
    func updateUserConstant(for username: String, key: String, value: String) -> Bool {
        
        do {
            
            let updateStatement: String = """
                UPDATE UserConstant SET value = '\(value)'
                WHERE key = '\(key)' AND username = '\(username)';
                """
            if let database = database {
                let updateSql = try database.prepareStatement(sql: updateStatement)
                defer {
                    database.finalize(updateSql)
                }
                guard database.step(updateSql) == SQLITE_DONE else {
                    print("Failure in updating UserConstant table")
                    print(database.errorMessage)
                    return false
                }
                print("Successfully updated row.")
                return true
            } else {
                print("No database connection")
                return false
            }
        } catch let error {
            print("Failed to update a row in UserConstant table")
            print(error)
            return false
        }
    }
    
    func createUserConstant(for username: String, key: String, value: String) -> Bool {
        let insertStatement: String =
        """
        INSERT INTO UserConstant(username, key, value)
        VALUES ('\(username)', '\(key)', '\(value)');
        """
        do {
            if let database = database {
                let insertSql = try database.prepareStatement(sql: insertStatement)
                defer {
                    database.finalize(insertSql)
                }
                /// Executing the query
                guard database.step(insertSql) == SQLITE_DONE else {
                    throw SQLiteError.stepError(message: database.errorMessage)
                }
                
                print("Successfully inserted row in UserConstant table")
                return true
            } else {
                print("No database connection")
                return false
            }
        } catch SQLiteError.stepError(message: let error) {
            print("Cannot create entry in UserConstant table")
            print(error)
            return false
        } catch SQLiteError.preparationError(message: let error) {
            print("Cannot create entry in UserConstant table")
            print(error)
            return false
        } catch let error {
            print("Cannot create entry in UserConstant table")
            print(error)
            return false
        }
    }
    
    private func createDefaultConstants(for username: String) {
        
        
        let defaultConstants = [
            "reminderTimeInterval": "3600",
            "reminderTitle": "Untitled",
            "reminderDescription": "Description",
            "reminderRepeatPattern": "never",
            "reminderRingTimeIntervals": "1800"
        ]
        for (key, value) in defaultConstants {
            if createUserConstant(for: username, key: key, value: value) == false {
                print("Unable to set constant \"\(key)\" for user \"\(username)\"")
            }
        }
    }
}
