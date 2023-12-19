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

struct TaskError {
    let message: String
    let type: ErrorType
}


protocol FirestoreImplementation {
    associatedtype T: DocumentProtocol
    func saveData(data: T) async -> Result<(T,String), Error>
    func updateData(data: T) async -> Result<T, Error>
    func getAllData() async -> Result<[T], Error>
    func queryData(field: String, value: String, isArray: Bool) async -> Result<[T], Error>
    func queryMultipleData(field: String, values: [String]) async -> Result<[T], Error>
    func getSingleData(id: String) async -> Result<T, Error>
    func deleteData(id: String?) async -> Result<Void, Error>
}


class FirebaseDataSource<T : DocumentProtocol>: FirestoreImplementation {
  
    
    
    typealias T = T
    let databaseProtocol: any DatabaseProtocol
    
    init(databaseProtocol: any DatabaseProtocol) {
        self.databaseProtocol = databaseProtocol
    }
    
    
    func saveData(data: T) async -> Result<(T,String), Error> {
        do {
            let reference = collectionReference().document()
            try reference.setData(from: data)
            return Result.success((data, reference.documentID))
    
        } catch {
            return Result.failure(error)
        }
     
    }

    
    func updateData(data: T) async -> Result<T,Error> {
      
        do {
            try collectionReference().document(data.id!).setData(from: data)
            return Result.success(data)
        } catch {
            return Result.failure(error)
        }
    }
    

    func deleteData(id: String?) async -> Result<Void,Error> {
        do  {
            try await collectionReference().document(id!).delete()
            return .success(())
        } catch {
            return Result.failure(error)
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

    
    func mapSnapshot(querySnapshot: DocumentSnapshot) -> T? {
        do  {
            var data = try querySnapshot.data(as: T.self) as T
            data.id = querySnapshot.documentID
            return  data
        } catch {
            getLogger().error("\(error.localizedDescription)")
            return nil
        }
    }
    func mapSnapshot(querySnapshot: QueryDocumentSnapshot) -> T? {
        do  {
            var data = try querySnapshot.data(as: T.self) as T
            data.id = querySnapshot.documentID
            return  data
        } catch {
            getLogger().error("\(error.localizedDescription)")
            return nil
        }
    }
    
    func handleSnapshotArray(querySnapshot: [QueryDocumentSnapshot]) -> [T]  {
        return querySnapshot.compactMap({ document in
            mapSnapshot(querySnapshot: document)
        })
    }
    func handleSnapshotArray(querySnapshot: QuerySnapshot) -> [T]  {
        return querySnapshot.documents.compactMap({ document in
            mapSnapshot(querySnapshot: document)
        })
    }

    
    func returnError(error: Error) -> Result<Any, Error> {
        return .failure(error)
    }
    

    func getAllData() async -> Result<[T], Error> {
        getLogger().info("Fetching all data from \(self.databaseProtocol.path)")
        do {
            let docs =  try await collectionReference().getDocuments()
            let mappedDocs = handleSnapshotArray(querySnapshot: docs.documents)
            return .success(mappedDocs)
        } catch {
            return .failure(error)
        }
    }
    
    func queryData(field: String, value: String, isArray: Bool) async -> Result<[T], Error> {
        Logger.init().info("Querying data on \(self.databaseProtocol.path) \(field) = \(value)")
        do {
            let query = if(isArray) {
                collectionReference().whereField(field, arrayContains: value)
            } else {
                collectionReference().whereField(field, isEqualTo: value)
            }
            let docs = try await query.getDocuments()
            let mappedDocs = handleSnapshotArray(querySnapshot: docs)
            return .success(mappedDocs)
          
        } catch {
            return .failure(error)
        }
    }
    
    func queryMultipleData(field: String, values: [String]) async -> Result<[T], Error> {
        Logger.init().info("Querying data on \(self.databaseProtocol.path) \(field) = \(values)")
        do {
            let query = collectionReference().whereField(field, in: values)
            let docs = try await query.getDocuments()
            let mappedDocs = handleSnapshotArray(querySnapshot: docs)
            return .success(mappedDocs)
        } catch {
            return .failure(error)
        }

    }
    
    func getSingleData(id: String) async -> Result<T, Error> {
        getLogger().info("Querying data from \(self.databaseProtocol.path) with key \(id)")
        do {
            let document = try await collectionReference().document(id).getDocument()
            if(document.exists) {
                return .success(mapSnapshot(querySnapshot: document)!)
            } else {
                throw NSError(domain: "Nenis/\(self.databaseProtocol.path)", code: 404, userInfo: ["id":id] )
            }
        } catch {
            getLogger().error("Error fetching data from \(self.databaseProtocol.path) with key \(id)")

            return .failure(error)
        }
    }
    
}
