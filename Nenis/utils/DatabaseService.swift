//
//  DatabaseService.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import os

protocol DatabaseProtocol {
    associatedtype T
    var delegate: any DatabaseDelegate<T> { get }
    var path: String { get }
    func getAllData()
    func queryData(field: String, value: String, isArray: Bool)
    func getSingleData(id: String)
    func saveData(data: T)
    func updateData(id: String?, data: T)
    func deleteData(id: String?)
}

extension DatabaseProtocol {
    
    func collectionReference() -> CollectionReference {
        Firestore.firestore().collection(path)
    }
    
    func currentUser() -> User? {
       return Auth.auth().currentUser
    }
    
    func getLogger() -> Logger {
        return Logger.init()
    }
    
    func sendError(message: String, errorType: ErrorType) {
        getLogger().error("\(message)")
        delegate.taskFailure(databaseError: errorType)
    }
    
    

}


protocol DatabaseDelegate<T> {
    associatedtype T
    func retrieveListData(dataList: [T])
    func retrieveData(data: T)
    func saveSuccess(data: T)
    func taskFailure(databaseError: ErrorType)
    func taskSuccess(message: String)
}

enum ErrorType {
    case update, query, fetch, delete, save
    var description: String {
        get {
            switch self {
                
            case .save:
                "Error saving data."
            case .update:
                "Error updating data."
            case .query:
                "Error querying data"
            case .fetch:
                "Error fetching data"
            case .delete:
                "Error deleting data"
            }
        }
    }
}
