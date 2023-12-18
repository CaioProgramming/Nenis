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
    associatedtype T : Codable
    var path: String { get }
    var delegate: any DatabaseDelegate<T> { get }
    var firebaseDataSource: FirebaseDataSource<T>? { get }
    func mapSnapshot(querySnapshot: DocumentSnapshot) -> T?
    
}


extension DatabaseProtocol {
    
    
    func mapSnapshot(querySnapshot: DocumentSnapshot) -> T? {
        do  {
            var data = try querySnapshot.data(as: T.self) as T
            return  data
        } catch {
            sendError(message: "Error mapping snapshot \(error.localizedDescription)", errorType: .delete)
            return nil
        }
    }
    
    
    func handleSnapshotArray(querySnapshot: [QueryDocumentSnapshot], isQuery: Bool) {
        
        let childArray = querySnapshot.compactMap( { doc in
            
            let data = mapSnapshot(querySnapshot: doc)
            return data
            
        })
        print("Data => \(childArray)")
        if (!childArray.isEmpty) {
            delegate.retrieveListData(dataList: childArray)
        } else {
            if(isQuery) {
                self.delegate.taskFailure(databaseError: .query)
            } else {
                self.delegate.taskFailure(databaseError: .fetch)
            }
        }
    }
    
    func handleDocSnapshot(docSnapshot: DocumentSnapshot) {
            if let dataModel = mapSnapshot(querySnapshot: docSnapshot) {
                self.delegate.retrieveData(data: dataModel)
            }
    }
}



protocol FirestoreImplementation {
    associatedtype T: Encodable
    func saveData(data: T,  completition: @escaping (T, String) -> Void)
    func updateData(id: String?, data: T,  completition: @escaping (T) -> Void)
    func getAllData()
    func queryData(field: String, value: String, isArray: Bool)
    func getSingleData(id: String)
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
    
    func sendError(message: String?, errorType: ErrorType) {
        getLogger().error("\(message ?? "Error on executing function")")
        delegate.taskFailure(databaseError: errorType)
    }
    
    
    
}


protocol DatabaseDelegate<T> {
    associatedtype T
    func retrieveListData(dataList: [T])
    func retrieveData(data: T)
    func saveSuccess(data: T)
    func updateSuccess(data: T)
    func taskFailure(databaseError: ErrorType)
    func taskSuccess(message: String)
}

extension DatabaseDelegate {
    func logger() -> Logger { return Logger() }
    
    func taskFailure(databaseError: ErrorType) {
        logger().error("Task failed -> \(databaseError.description)")
    }
    
    func taskSuccess(message: String) {
        logger().debug("Task success -> \(message)")
        
    }
    
    func saveSuccess(data: T) {}
    func updateSuccess(data: T) {}
    
    func retrieveData(data: T) {
        logger().info("Data retrieved -> \(String(describing: data))")
    }
    
    func retrieveListData(dataList: [T]) {
        logger().info("Data retrieved -> \(String(describing: dataList))")

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
