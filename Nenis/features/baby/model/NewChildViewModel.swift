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


class NewChildViewModel {
    
   private var photo: Data? = nil

    var babyService = BabyService()
    var storageService: StorageSource = StorageSource(path: "Childs")

    var delegate: NewChildProtocol? = nil
    
    private func uploadPic(id: String, child: Child, file: Data) {
        Task {
            await storageService
                .uploadFile(
                    fileName: id,
                    fileData: file,
                    extension:".JPEG",
                    onSuccess: { downloadURL in
                        self.updateChildPic(with: child, url: downloadURL)
                    },
                    onError: {_ in
                        sendError(messsage: "Erro ao salvar foto da criança.")
                    })
        }
    }
    
    func updateChildPic(with child: Child, url: String) {
        
        Task {
            var newChild = child
            newChild.photo = url
            
           await babyService.updateData(data: newChild, onSuccess: { updatedChild in
                delegate?.saveSuccess(child: updatedChild)
            }, onFailure: { error in
            
                sendError(messsage: "Erro ao concluir informações da criança.")
            })
        }
    }
    
    func saveChild(name: String, birthDate: Date, photoPath: Data, gender: String) {
        if let currentUser = Auth.auth().currentUser {
            Task {
                let child = Child(name: name, birthDate: birthDate, photo: "", gender: gender,tutors: [currentUser.uid])
                await babyService.saveData(
                    data: child,
                    onSuccess: { savedChild, id in
                        self.uploadPic(id: id, child: savedChild, file: photoPath)
                    },
                    onFailure: { error in
                        sendError(messsage: "Erro ao salvar dados.")
                    }
                )
            }
        }
    }
    
    
    private func sendError(messsage: String) {
        delegate?.errorSaving(errorMessage: messsage)
    }
}
