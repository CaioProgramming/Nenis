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
            var data = try querySnapshot.data(as: Child.self) as Child
            data.id = querySnapshot.documentID
            return  data
        } catch {
            sendError(message: "Error mapping snapshot \(error.localizedDescription)", errorType: .delete)
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
        firebaseDataSource?.getAllData()
    }
    
    func queryData(field: String, value: String, isArray: Bool){
        Logger.init().info("Querying data from \(self.path) \(field) = \(value)")
        firebaseDataSource?.queryData(field: field, value: value, isArray: isArray)
    }
    
    
    func getSingleData(id: String) {
        firebaseDataSource?.getSingleData(id: id)
    }
    
    func saveData(data: Child) {
        firebaseDataSource?.saveData(data: data, completition: { (newData, docId) in
            self.delegate.taskSuccess(message: "Data saved sucessfully.")
            var savedData = data
            savedData.id = docId
            self.delegate.saveSuccess(data: savedData)
        })

    }
    
    func updateData(data: Child) {
        firebaseDataSource?.updateData(id: data.id, data: data, completition: { newData in
            self.delegate.taskSuccess(message: "Data supdated sucessfully.")
            self.delegate.updateSuccess(data: data)
        })
    }
    
    func deleteData(id: String?) {
        firebaseDataSource?.deleteData(id: id)
    }
    
    
    
    
    
}
