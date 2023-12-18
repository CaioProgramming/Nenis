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
    associatedtype T : DocumentProtocol
    var path: String { get }
    var dataSource: FirebaseDataSource<T>? { get }
    
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
    
    func saveData(data: T, onSuccess: (T, String) -> Void, onFailure: (Error) -> Void) async {
        do {
            if let task = try await dataSource?.saveData(data: data).get() {
                onSuccess(task.0, task.1)
            }
        } catch {
            onFailure(error)
        }
    }
    
    func updateData(data: T, onSuccess: (T) -> Void, onFailure: (Error) -> Void) async {
        do {
            if let task = try await dataSource?.updateData(data: data).get() {
                onSuccess(task)
            }

        } catch {
            onFailure(error)
        }
    }
    
    func deleteData(id: String?, onSuccess: () -> Void, onFailure: (Error) -> Void) async {
        do {
            try await dataSource?.deleteData(id: id).get()
            onSuccess()
        } catch {
            onFailure(error)
        }
    }
    
    func getAllData(onSuccess: (([T]) -> Void), onFailure: (Error) -> Void) async {
        do {
            if let task = try await dataSource?.getAllData().get() {
                onSuccess(task)
            }
        } catch {
            onFailure(error)
        }
    }
    
    func getSingleData(id: String, onSuccess: (T) -> Void, onFailure: (Error) -> Void) async {
        do {
            if let task = try await dataSource?.getSingleData(id: id).get() {
                onSuccess(task)
            }

        } catch {
            onFailure(error)
        }
    }
    
    func queryData(field: String, value: String, isArray: Bool, onSuccess: (([T]) -> Void), onFailure: (Error) -> Void) async {
        do {
            if let task = try await dataSource?.queryData(field: field, value: value, isArray: isArray).get() {
                onSuccess(task)
            }
            
        } catch {
            onFailure(error)
        }
       
    }
    
}



enum ErrorType {
    case update, query, fetch, delete, save, parse
    var description: String {
        get {
            switch self {
            case .parse:
                "Error mapping data"
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
