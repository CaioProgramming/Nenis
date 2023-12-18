//
//  FirebaseDataSource.swift
//  Nenis
//
//  Created by Caio Ferreira on 14/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import os

class FirebaseDataSource<T : DocumentProtocol>: FirestoreImplementation {
    
    typealias T = T
    let databaseProtocol: any DatabaseProtocol
    
    init(databaseProtocol: any DatabaseProtocol) {
        self.databaseProtocol = databaseProtocol
    }
    
    
    func saveData(data: T, completition: @escaping (T, String) -> Void) {
        do {
            let reference = collectionReference().document()
            try reference.setData(from: data, completion: { error in
                if let taskError  = error {
                    self.sendError(message: "Error executing save \(taskError.localizedDescription)", errorType: .save)
                } else {
                    completition(data, reference.documentID)
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
