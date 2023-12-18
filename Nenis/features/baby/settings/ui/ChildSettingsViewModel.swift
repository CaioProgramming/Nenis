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
    private let storageService: StorageSource = StorageSource(path: "Childs")
    private let service = BabyService()
    
    private func deletePhoto(child: Child,_ onComplete: @escaping () -> Void) {
        Task {
            await storageService.deleteFile(fileName: child.id!,
                                            onSuccess: onComplete,
                                            onError: { _ in })
        }
    }
    
    func updateChild(newChild: Child) {
        Task {
            await service
                .updateData(
                    data: newChild,
                    onSuccess: retrieveData,
                    onFailure: { _ in }
                )
        }
    }
    
    private func changePhotoURL(url: String, with child: Child) {
        var newChild = child
        newChild.photo = url
        updateChild(newChild: newChild)
    }
    
    func updatePhoto(with photo: UIImage) {
        guard let child = currentChild, let childPic = photo.jpegData(compressionQuality: 1), let id = child.id else {
            print("No child selected")
            return
        }
        deletePhoto(child: child) {
            Task {
                await self
                    .storageService
                    .uploadFile(fileName: id,
                                fileData: childPic,
                                extension: ".JPEG",
                                onSuccess: { url in self.changePhotoURL(url: url, with: child) },
                                onError: { _ in })
            }
        }
    }
    
    
    
    
    
    func setupChild(child: Child) {
        Task {
            await service.getSingleData(id: child.id!, onSuccess: retrieveData, onFailure: { _ in })
        }
    }
    
    func retrieveData(data: Child) {
        DispatchQueue.main.async {
            self.currentChild = data
            self.buildSections(with: data)
        }
    }
    
    func deleteChild(with child: Child) {
        
    }
    
    
    func buildSections(with child: Child) {
        let childSection = ChildSection( title: "", subtitle: "", items: [child], itemClosure: { child, view in
            self.delegate?.requestUpdatePicture()
        })
        
        let optionsSection = OptionSection( items: Option.allCases,
                                            itemClosure: { option, view in
            
            self.selectedOption = option
            self.delegate?.selectOption(option: option)
        }, 
                                            footerData: FooterComponent(
                                                message: "Suas informações estão sempre protegidas.",
                                                actionLabel: "Excluir",
                                                messageIcon: UIImage(systemName: "lock.circle.dotted"),
                                                actionClosure: { _ in
                                                    self.deleteChild(with: child)
                                                })
        )
        
        delegate?.retrieveSections(sections: [childSection, optionsSection])
    }
    
    
    
    
}

extension ChildSettingsViewModel {
    
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
            "Informações"
        case .tutors:
            "Responsáveis"
        case .vaccines:
            "Vacinas"
        case .diapers:
            "Fraldas"
        case .actions:
            "Atividades"
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
