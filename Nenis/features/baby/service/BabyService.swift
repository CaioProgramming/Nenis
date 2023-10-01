//
//  BabyService.swift
//  Nenis
//
//  Created by Caio Ferreira on 28/09/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import os

protocol ServideProtocol {
    
}

class BabyService: DatabaseProtocol {
    
    
    
    typealias T = Child
    var path = "Childs"
    var delegate: any DatabaseDelegate<Child>
    var firebaseDataSource: FirebaseDataSource<Child>?
    
    init(delegate: any DatabaseDelegate<Child>) {
        self.delegate = delegate
        self.firebaseDataSource = FirebaseDataSource(databaseProtocol: self)
    }
    
    
    func mapSnapshot(querySnapshot: DocumentSnapshot) -> Child? {
        do  {
            return try querySnapshot.data(as: Child.self)
        } catch {
            return nil
        }
        
    }
    

  
    
    private func handleSnapshot(querySnapshot: [QueryDocumentSnapshot], isQuery: Bool) {
        let childArray = querySnapshot.compactMap( { doc in
            do {
                var child = try doc.data(as: Child.self)
                child.id = doc.documentID
                return child
            } catch {
                getLogger().error("Failed to map snapshot \(error)")
                return nil
            }
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
    
    
    func validateQueryCompletition(querySnapshot: QuerySnapshot?, error: Error?, isQuery: Bool) {
        guard let queryError = error else {
            if let documents =  querySnapshot?.documents {
                self.handleSnapshot(querySnapshot: documents, isQuery: isQuery)
            }
            return
        }
        let errorType: ErrorType = (isQuery) ? .query : .fetch
        getLogger().error("Error getting documents \(queryError.localizedDescription)")
        self.delegate.taskFailure(databaseError: errorType)
    }
    
    func getAllData() {
        getLogger().info("Fetching all data from \(self.path)")
        collectionReference().getDocuments() { snapshot, error in
            self.validateQueryCompletition(querySnapshot: snapshot, error: error, isQuery: false)
        }
    }
    
    func queryData(field: String, value: String, isArray: Bool){
        Logger.init().info("Querying data from \(self.path) \(field) = \(value)")

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
        getLogger().info("Querying child from \(self.path) = \(id)")
        collectionReference().document(id).getDocument(as: T.self) { result in
            switch result {
            case .success(let child):
                self.delegate.retrieveData(data: child)
            case .failure(let error):
                self.sendError(message: "Failed to get document \(error.localizedDescription)", errorType: .query)
            }
        }
    }
    
    func saveData(data: Child) {
        getLogger().info("Saving child on \(self.path)")
        print(data)
        do {
            try collectionReference().document().setData(from: data) { error in
                
                if let saveError = error {
                    self.sendError(message: "Error saving data \(saveError.localizedDescription)", errorType: .save)
                } else {
                    self.delegate.taskSuccess(message: "Data saved sucessfully.")
                    self.delegate.saveSuccess(data: data)
                }
            }
        } catch {
            sendError(message: "Error saving data \(error.localizedDescription)", errorType: .save)
        }
       
    }
    
    func updateData(id: String?, data: Child) {
        Logger.init().info("Updating data on \(self.path):\(id ?? "no id provided")")
        print(data)
        do {
            if let docId = id {
                try collectionReference().document(docId).setData(from: data) { error in
                    
                    if let saveError = error {
                        self.delegate.taskFailure(databaseError: .update)
                    } else {
                        self.delegate.taskSuccess(message: "Data supdated sucessfully.")
                        self.delegate.retrieveData(data: data)
                    }
                }
            } else {
                sendError(message: "Error updating data. No ID provided", errorType: .update)
            }
            
        } catch {
            sendError(message: "Error updating data \(error.localizedDescription)", errorType: .update)
        }
    }
    
    func deleteData(id: String?) {
        getLogger().warning("Deleting data on \(self.path) = \(id ?? "No id provided!")")
        if let docId = id {
            collectionReference().document(docId).delete() { error in
                    
                    if let saveError = error {
                        self.sendError(message: "Error deleting data \(saveError.localizedDescription)", errorType: .delete)
                    } else {
                        self.delegate.taskSuccess(message: "Data deleted sucessfully.")
                    }
                }
        }
        
        
    }
    
    
    
    
    
}
