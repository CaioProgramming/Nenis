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

class NewChildViewModel {
    
    let path = "Childs"
    var newChildDelegate: NewChildProtocol? = nil
    
    func saveChild(name: String, birthDate: Date, photoPath: Data) {
        if let currentUser = Auth.auth().currentUser {
            uploadPhoto(name: name, path: photoPath, taskCompletition: { (metadata, error) in
                if(metadata == nil || error != nil) {
                    
                    Logger.init().error("Error uploading photo! -> \n\(error.debugDescription)")
                    Logger.init().critical("\(error.debugDescription)")
                    self.sendError(messsage: "Error uploading photo")
                } else {
                    self.getStoragePath().child(name).downloadURL { url, error in
                        if let downloadUrl = url {
                            print("\(name) photo upload success -> \(downloadUrl)" )
                            let child = Child(name: name, birthDate: birthDate, photo: downloadUrl.path(), tutors: [currentUser.uid], actions: [])
                            print("saving child -> \(child)")
                            self.saveToDatabase(child: child)
                        }
                    }
                }
            }
            )
        } else {
            newChildDelegate?.errorSaving(errorMessage: "User not authenticated")
        }
    }
    
    private func getStoragePath() -> StorageReference {
        let storagePath = Storage.storage().reference().child(path)
        return storagePath
    }
    
    private func databaseReference() -> Firestore {
        return Firestore.firestore()
    }
    
    private func sendError(messsage: String) {
        newChildDelegate?.errorSaving(errorMessage: messsage)
    }
    
    private func saveToDatabase(child: Child) {
        
        let newChild = databaseReference().collection(path).document()
        do {
            try newChild.setData(from: child) { error in
                
                if let saveError = error {
                    self.sendError(messsage: saveError.localizedDescription )
                } else {
                    self.newChildDelegate?.saveSuccess(child: child)
                }
            }
        } catch {
            print(error.localizedDescription)
            newChildDelegate?.errorSaving(errorMessage: error.localizedDescription)
        }
    }
    
    private func cachePhoto(name: String, path: String, fileCopyCompletition: (URL) -> Void) {
        guard let url = URL(string: path) else {
            Logger.init().warning("Invalid url path -> \(path)")
            return
        }
        
        
        let fileName = "\(name)-\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
        // create new URL
        let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
        Logger.init().debug("File path -> \(url)")
        Logger.init().debug("Cache path -> \(newUrl)")
        // copy item to APP Storage
        do {
            try FileManager.default.copyItem(at: url, to: newUrl)
            Logger.init().debug("Cached file success.")
            fileCopyCompletition(newUrl)
        } catch {
            Logger.init().error("Error caching file \(error.localizedDescription)")
        }
    }
    
    private func uploadPhoto(name: String, path: Data, taskCompletition: @escaping ((StorageMetadata?, Error?) -> Void))  {
       
        print("Uploading photo to storage...")
        getStoragePath().child(name).putData(path, completion: taskCompletition)
        
    }
    
}
