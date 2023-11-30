//
//  ChildSettingsViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 29/11/23.
//

import Foundation
import UIKit

protocol SettingsDelegate {
    func requestUpdatePicture()
    func retrieveSections(sections: [any Section])
    func taskError(message: String)
    func selectOption(option: Option)
}

class ChildSettingsViewModel {
    
    var selectedOption: Option? = nil
    var delegate: SettingsDelegate? = nil
    var currentChild: Child? = nil
    var storageService: StorageService = StorageService(path: "Childs")
    var service: BabyService? = nil
    
    func updatePhoto(with photo: UIImage) {
        guard let child = currentChild, let childPic = photo.jpegData(compressionQuality: 1) else {
            print("No child selected")
            return
        }
        storageService.deleteFile(fileName: child.id ?? child.name, taskResult: { result in
            
            switch result {
            case .success(_):
                self.storageService.uploadFile(fileName: child.id ?? child.name, fileData: childPic, extension: ".JPEG", taskResult: { result in
                    
                    do {
                        var newChild = child
                        newChild.photo = try result.get()
                        self.service?.updateData(data: newChild)
                    } catch {
                        print("Upload error")
                    }
                })
            case .failure(_):
                self.delegate?.taskError(message: "Ocorreu um erro ao atualizar a foto")
            }
            
        })
        
        
    }
    
    
    
    
    func setupChild(child: Child) {
        if(service == nil) {
            service = BabyService(delegate: self)
        }
        self.currentChild = child
        buildSections(with: child)
    }
    
    
    func buildSections(with child: Child) {
        let childSection = ChildSection( title: "", subtitle: "", items: [child], itemClosure: { child in
            self.delegate?.requestUpdatePicture()
        })
        
        let optionsSection = OptionSection( items: Option.allCases, 
                                            itemClosure: { option in
            
            self.selectedOption = option
            self.delegate?.selectOption(option: option)
        }, footerData: ("Suas informaçoes sao protegidas.","Excluir", {
            print("confirm delete")
        }))
        
        delegate?.retrieveSections(sections: [childSection, optionsSection])
    }
    
    
    
    
}

extension ChildSettingsViewModel: DatabaseDelegate {
    
    typealias T = Child
    
    func updateSuccess(data: Child) {
        setupChild(child: data)
    }
}



enum Option: CaseIterable {
    case  info, tutors, vaccines, diapers, actions
    
    var title: String { get {
        switch self {
        case .info:
            "Informaçoes"
        case .tutors:
            "Responsáveis"
        case .vaccines:
            "Vacinas"
        case .diapers:
            "Fraldas"
        case .actions:
            "Atividade"
        }
    }
    }
    
    var icon: UIImage? {
        get {
            switch self {
            case .info:
                UIImage(systemName: "shared.with.you")
            case .tutors:
                UIImage(systemName: "person.2.fill")
            case .vaccines:
                UIImage(systemName: "heart.circle.fill")
            case .diapers:
                UIImage(named: "poop.fill")
            case .actions:
                UIImage(named: "baby.walk")
            
            }
        }
    }
    
    var color: UIColor {
        get {
            switch self {
            case .info:
                #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
            case .tutors:
                #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)
            case .vaccines:
                #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            case .diapers:
                ActionType.bath.imageTint
            case .actions:
                ActionType.exercise.imageTint
            }
        }
    }
    
}
