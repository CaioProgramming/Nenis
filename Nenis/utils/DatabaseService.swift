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
    associatedtype T : Encodable
    var path: String { get }
    var delegate: any DatabaseDelegate<T> { get }
    var firebaseDataSource: FirebaseDataSource<T>? { get }
    func mapSnapshot(querySnapshot: DocumentSnapshot) -> T?
    
}


extension DatabaseProtocol {
    
    
    
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
            }
            self.delegate.taskFailure(databaseError: .fetch)
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
    func saveData(data: T,  completition: @escaping (T) -> Void)
    func updateData(id: String?, data: T,  completition: @escaping (T) -> Void)
    func getAllData()
    func queryData(field: String, value: String, isArray: Bool)
    func getSingleData(id: String)
    func deleteData(id: String?)
}

class FirebaseDataSource<T : Encodable>: FirestoreImplementation {
    
    typealias T = T
    let databaseProtocol: any DatabaseProtocol
    
    init(databaseProtocol: any DatabaseProtocol) {
        self.databaseProtocol = databaseProtocol
    }
    
    
    func saveData(data: T, completition: @escaping (T) -> Void) {
        //databaseProtocol.executeSave(documentReference: collectionReference().document(), data: data)
        do {
            try collectionReference().document().setData(from: data, completion: { error in
                if let taskError  = error {
                    self.sendError(message: "Error executing save \(taskError.localizedDescription)", errorType: .save)
                } else {
                    completition(data)
                }
                
            })
        } catch {
            self.databaseProtocol.sendError(message: "Error executing save \(error.localizedDescription)", errorType: .update)

        }
     
    }

    
    func updateData(id: String?, data: T, completition: @escaping (T) -> Void) {
        guard id != nil else {
            getLogger().error("No id provided")
            self.sendError(message: "Error executing update ", errorType: .update)
            return
        }
        do {
            try collectionReference().document(id!).setData(from: data, completion: { error in
                if let taskError  = error {
                    self.sendError(message: "Error executing update \(taskError.localizedDescription)", errorType: .save)
                } else {
                    completition(data)
                }
            })
        } catch {
            self.databaseProtocol.sendError(message: "Error executing update \(error.localizedDescription)", errorType: .update)

        }
            
        
    }
    
    func deleteData(id: String?) {
        if let docID = id {
            collectionReference().document(docID).delete(){ error in
                if let taskError = error {
                    self.databaseProtocol.sendError(message: taskError.localizedDescription, errorType: .delete)
                } else {
                    self.databaseProtocol.delegate.taskSuccess(message: "Delete success!")
                }
            }
        } else {
            databaseProtocol.sendError(message: "Delete error, no ID provided!", errorType: .update)
        }
       
    }
    
    
  
    
    func collectionReference() -> CollectionReference {
        Firestore.firestore().collection(databaseProtocol.path)
    }
    
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func getLogger() -> Logger {
        return Logger.init()
    }
    
    func sendError(message: String, errorType: ErrorType) {
        getLogger().error("\(message)")
        databaseProtocol.delegate.taskFailure(databaseError: errorType)
    }
    
    
    
    func validateQueryCompletition(querySnapshot: QuerySnapshot?, error: Error?, isQuery: Bool) {
        guard let queryError = error else {
            if let documents =  querySnapshot?.documents {
                self.databaseProtocol.handleSnapshotArray(querySnapshot: documents, isQuery: isQuery)
            }
            return
        }
        let errorType: ErrorType = (isQuery) ? .query : .fetch
        getLogger().error("Error getting documents \(queryError.localizedDescription)")
        self.databaseProtocol.delegate.taskFailure(databaseError: errorType)
    }
    
    
    
    func getAllData() {
        getLogger().info("Fetching all data from \(self.databaseProtocol.path)")
        collectionReference().getDocuments() { snapshot, error in
            self.validateQueryCompletition(querySnapshot: snapshot, error: error, isQuery: false)
        }
    }
    
    func queryData(field: String, value: String, isArray: Bool) {
        Logger.init().info("Querying data from \(self.databaseProtocol.path) \(field) = \(value)")
        
        if(!isArray) {
            collectionReference().whereField(field, isEqualTo: value).getDocuments() { snapshot, error in
                self.validateQueryCompletition(querySnapshot: snapshot, error: error, isQuery: true)
            }
        } else {
            collectionReference().whereField(field, arrayContainsAny: [value]).getDocuments() { snapshot, error in
                self.validateQueryCompletition(querySnapshot: snapshot, error: error, isQuery: true)
            }
        }
    }
    
    func getSingleData(id: String) {
        getLogger().info("Querying child from \(self.databaseProtocol.path) with key \(id)")
        collectionReference().document(id).getDocument(completion: { snapshot, error in
            if let dataError = error {
                self.databaseProtocol.sendError(message: dataError.localizedDescription, errorType: .query)
            } else {
                if let docSnapshot = snapshot {
                    self.databaseProtocol.handleDocSnapshot(docSnapshot: docSnapshot)
                }
            }
        })
    }
    
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
