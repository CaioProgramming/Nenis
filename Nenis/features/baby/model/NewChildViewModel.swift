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
    
   private var photo: Data? = nil
    
    func updateSuccess(data: Child) {
        delegate?.saveSuccess(child: data)
    }
    
    
    func saveSuccess(data: Child) {
        guard let newPhoto = photo else {
            delegate?.errorSaving(errorMessage: "Image not uploaded")
            return
        }
        storageService?.uploadFile(fileName: data.id ?? data.name.addTimeInterval(), fileData: newPhoto, extension: ".JPEG") { downloadURL in
            do {
                let fileURL = try downloadURL.get()
                var childUpdate = data
                childUpdate.photo = fileURL
                self.babyService?.updateData(data: childUpdate)
                
            } catch {
                self.sendError(messsage: "Error uploading file.")
            }
        }
        
    }
    
    func taskFailure(databaseError: ErrorType) {
        delegate?.errorSaving(errorMessage: databaseError.description)
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
    
    var delegate: NewChildProtocol? = nil
    
    
    func saveChild(name: String, birthDate: Date, photoPath: Data, gender: String) {
        if let currentUser = Auth.auth().currentUser {
            self.babyService?.saveData(data: Child(name: name, birthDate: birthDate, photo: "", gender: gender,tutors: [currentUser.uid]))
            self.photo = photoPath
            storageService?.uploadFile(fileName: name, fileData: photoPath, extension: ".JPEG") { downloadURL in
                do {
                    let fileURL = try downloadURL.get()
                    self.babyService?.saveData(data: Child(name: name, birthDate: birthDate, photo: fileURL, gender: gender,tutors: [currentUser.uid]))
                    
                } catch {
                    self.sendError(messsage: "Error uploading file.")
                }
            }
        } else {
            delegate?.errorSaving(errorMessage: "User not authenticated")
        }
    }
    
    
    private func sendError(messsage: String) {
        delegate?.errorSaving(errorMessage: messsage)
    }
}
