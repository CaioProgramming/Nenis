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
    
    
    private func selectOption(option: Option) {
        self.selectedOption = option
        self.delegate?.selectOption(option: option)
    }
    
    func buildSections(with child: Child) {
        let userHelper = UserHelper()
        userHelper.getUsers(ids: child.tutors, with: { tutors in
        
            DispatchQueue.main.async { [self] in
                let childFooter = FooterComponent(message: "", actionLabel: "", messageIcon: nil, actionClosure: { view in
                
                    view?.fadeOut(onCompletion: {
                        self.selectOption(option: Option.tutors)
                        view?.fadeIn()
                    })

                    
                })
                let childSection = ChildSection( title: "",
                                                 subtitle: "",
                                                 items: [child],
                                                 tutors: tutors,
                                                 itemClosure: { child, view in self.delegate?.requestUpdatePicture() },
                                                 footerData: childFooter
                )
                
                let optionsSection = OptionSection( items: Option.allCases,
                                                    itemClosure: { option, view in
                    self.selectOption(option: option)
                }
                )
                var sections: [any Section] = [childSection, optionsSection]
                child.extraInfo.forEach({ data in
                    let iconOption = IconOptions.getIconByName(value: data.icon).map({ option in
                    
                        IconConfiguration(image: option.icon, tintColor: option.color)
                    })
                    let header = HeaderComponent(title: data.title, actionLabel: nil, actionIcon: nil, trailingIcon: iconOption, actionClosure: nil)
                    let footer: FooterComponent? = if(data != child.extraInfo.last) { nil } else {
                        FooterComponent(
                            message: "Suas informações estão sempre protegidas.",
                            actionLabel: "Excluir",
                            messageIcon: IconConfiguration(image: UIImage(systemName: "lock.circle.dotted"),
                                                           tintColor: UIColor.link) ,
                            actionClosure: { _ in
                        
                                self.deleteChild(with: child)
                        
                            }
                        )
                    }
                    let section = SettingsDetailsSection(items: data.infos, itemClosure: { _ ,_ in
                        
                        self.selectOption(option: .info)
                        
                    },
                                                         headerData: header,
                                                         footerData: footer,
                                                         headerMenuClosure: { _ in}, editingStyle: .none, isSettings: true)
                    sections.append(section)
                })
                
                delegate?.retrieveSections(sections: sections)
            }
        })
    
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
