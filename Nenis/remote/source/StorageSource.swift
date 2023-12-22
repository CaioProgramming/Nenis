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
    func uploadFile(fileName: String, fileData: Data, extension: String, onSuccess: (String) -> Void, onError: (Error) -> Void) async
    func deleteFile(fileName: String, onSuccess: () -> Void, onError: (Error) -> Void) async
}
enum StorageError: Error {
    case upload, url
}

class StorageSource: StorageProtocol {
    
    
        private func getStoragePath() -> StorageReference {
            let storagePath = Storage.storage().reference().child(path)
            return storagePath
        }
    
    private func handleCompletition(metadaData: StorageMetadata?, error: Error?) -> Result<Bool, StorageError> {
        
        if error != nil {
            return .failure(.upload)
        } else {
            return .success(metadaData != nil)
        }
        
    }
    
    func handleDownloadURL(url: URL?, error: Error?) -> String? {
        if error != nil {
            return nil
        }
        if let downloadURL = url {
            return downloadURL.absoluteString
        } else {
            return nil
        }
    }
    
    func deleteFile(fileName: String, onSuccess: () -> Void, onError: (Error) -> Void)  async {
        
        let reference = getStoragePath().child(fileName.removingBlankSpaces())
        do {
            try await reference.delete()
            onSuccess()
        } catch {
            onError(error)
        }

    }
    
    func uploadFile(fileName: String, fileData: Data, extension: String, onSuccess: (String) -> Void, onError: (Error) -> Void) async {
        print("Uploading file to storage...")
        do {
            let reference = getStoragePath().child(fileName.removingBlankSpaces())
            try await reference.putDataAsync(fileData)
            let downloadURL = try await reference.downloadURL()
            onSuccess(downloadURL.absoluteString)
            
        } catch {
            onError(error)
        }
    }
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    
    
}

