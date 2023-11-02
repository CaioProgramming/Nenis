//
//  StorageService.swift
//  Nenis
//
//  Created by Caio Ferreira on 28/09/23.
//

import Foundation
import FirebaseStorage
import os

protocol StorageProtocol {
    func uploadFile(fileName: String, fileData: Data, extension: String, taskResult: @escaping (Result<String,StorageError>) -> Void)
}
enum StorageError: Error {
    case upload, url
}

class StorageService: StorageProtocol {
    
    
        private func getStoragePath() -> StorageReference {
            let storagePath = Storage.storage().reference().child(path)
            return storagePath
        }
    
    private func handleCompletition(metadaData: StorageMetadata?, error: Error?) -> Result<Bool, StorageError> {
        
        if let taskError = error {
            return .failure(.upload)
        } else {
            return .success(metadaData != nil)
        }
        
    }
    
    func handleDownloadURL(url: URL?, error: Error?) -> String? {
        if let taskError = error {
            return nil
        }
        if let downloadURL = url {
            return downloadURL.absoluteString
        } else {
            return nil
        }
    }
    
    func uploadFile(fileName: String, fileData: Data, extension: String, taskResult: @escaping (Result<String,StorageError>) -> Void) {
        print("Uploading file to storage...")
        let longDate = Date.now.timeIntervalSince1970
        let reference = getStoragePath().child("\(fileName.replacingOccurrences(of: " ", with: ""))_\(longDate)")
        reference.putData(fileData) { metaData, error in
                
            do {
                let result = try self.handleCompletition(metadaData: metaData, error: error).get()

                if(result) {
                    do {
                        
                    }
                    reference.downloadURL { fileUrl, error in
                        if let downloadURL = self.handleDownloadURL(url: fileUrl, error: error) {
                            taskResult(.success(downloadURL))
                        }
                    }
                }
            
            } catch {
                Logger.init().error("Error uploading file \(error)")
                taskResult(.failure(.upload))
                
            }
            
            
            
            
        }
    }
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    
    
}

