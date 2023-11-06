//
//  ChildViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/09/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import os


protocol NewChildProtocol {
    
    func saveSuccess(child: Child)
    func errorSaving(errorMessage: String)
}

struct UploadTask {
    let error: String?
    let sucess: String?
}

class NewChildViewModel: DatabaseDelegate {
    
    func updateSuccess(data: Child) {
        
    }
    
    
    func saveSuccess(data: Child) {
        newChildDelegate?.saveSuccess(child: data)
    }
    
    func taskFailure(databaseError: ErrorType) {
        newChildDelegate?.errorSaving(errorMessage: databaseError.description)
    }
    
    
    func retrieveListData(dataList: [Child]) {
        
    }
    
    func retrieveData(data: Child) {
        
    }
    
    func taskSuccess(message: String) {
        
    }
    
    typealias T = Child
    
    
    var babyService : BabyService? = nil
    var storageService: StorageService? = nil
    init() {
        self.babyService = BabyService(delegate: self)
        self.storageService = StorageService(path:"Childs")
        
    }
    
    var newChildDelegate: NewChildProtocol? = nil
    
    
    func saveChild(name: String, birthDate: Date, photoPath: Data, gender: String) {
        if let currentUser = Auth.auth().currentUser {
            storageService?.uploadFile(fileName: name, fileData: photoPath, extension: ".JPEG") { downloadURL in
                do {
                    let fileURL = try downloadURL.get()
                    self.babyService?.saveData(data: Child(name: name, birthDate: birthDate, photo: fileURL, gender: gender,tutors: [currentUser.uid], actions: []))
                    
                } catch {
                    self.sendError(messsage: "Error uploading file.")
                }
            }
        } else {
            newChildDelegate?.errorSaving(errorMessage: "User not authenticated")
        }
    }
    
    
    private func sendError(messsage: String) {
        newChildDelegate?.errorSaving(errorMessage: messsage)
    }
}
