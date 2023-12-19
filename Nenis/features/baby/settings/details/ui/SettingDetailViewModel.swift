//
//  SettingDetailViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 30/11/23.
//

import Foundation
import UIKit

protocol DetailProtocol {
    func retrieveSections(_ sections :[any Section])
    func setupNavItem(option: Option)
    func requestNewGroupInfo()
    func requestNewInfo(group: Int, sender: UIView?)
    func showEditForDetail(groupIndex: Int, itemIndex: Int, item: DetailModel, view: UIView?)
    func showEditName(view: UIView?, name: String)
    func showEditBirthDate(view: UIView?)
    func showEditGender(view: UIView?)
}

protocol InfoProtocol {
    func editName(_ name: String)
    func editBirthDate(_ date: Date)
    func editGender(gender: Gender)
    func addNewGroupInfo(extraData: ExtraData)
    func deleteGroupInfoData(groupIndex: Int, itemIndex: Int)
    func editGroupInfoData(groupIndex: Int, itemIndex: Int, item: DetailModel)
    func addItemToGroup(groupIndex: Int ,item: DetailModel)
    func buildSectionsForInfo() -> [any Section]
}

protocol VaccineDetailProtocol {
    func buildSectionsForVaccine() -> [VaccineSettingsSection]
    func clearVaccineData()
}

protocol DiaperDetailProtocol {
    func buildSectionsForDiapers() -> [DiaperDetailSection]
    func deleteDiaper(diaper: Diaper)
}

protocol ActionDetailProtocol {
    func buildSectionsForActions() -> [ActionSettingSection]
}

protocol TutorDetailProtocol {
    func buildSectionsForTutor(tutors: [Tutor]) -> [TutorSection]
    func deleteTutor(index: Int)
}

class SettingDetailViewModel {
    typealias T = Child
    
    var babyService = BabyService()
    var child: Child? = nil
    var selectedOption: Option? = nil
    var delegate: DetailProtocol? = nil
    func setupDetail(with selectedChild: Child?, option: Option?) {
        child = selectedChild
        selectedOption = option
        switch option {
        case .info:
            delegate?.retrieveSections(buildSectionsForInfo())
        case .vaccines:
            delegate?.retrieveSections(buildSectionsForVaccine())
        case .diapers:
            delegate?.retrieveSections(buildSectionsForDiapers())
        case .actions:
            delegate?.retrieveSections(buildSectionsForActions())
        case .tutors:
            getTutors()
        default: break
        }
        if let currentOption = selectedOption {
            delegate?.setupNavItem(option: currentOption)
            
        }
    }
    
    
    
    func updateSuccess(data: Child) {
        DispatchQueue.main.async {
            self.delegate?.retrieveSections([])
            self.setupDetail(with: data, option: self.selectedOption)
        }
        
    }
    
    private func updateChild(newChild: Child) {
        Task {
            await babyService
                .updateData(
                    data:newChild,
                    onSuccess: updateSuccess,
                    onFailure: { _ in }
                )
        }
    }
    
}


extension SettingDetailViewModel: InfoProtocol {
    
    func editGender(gender: Gender) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.gender = gender.description
            updateChild(newChild: newChild)
        }
    }
    
    
    func editName(_ name: String) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.name = name
            updateChild(newChild: newChild)
        }
    }
    
    func editBirthDate(_ date: Date) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.birthDate = date
            updateChild(newChild: newChild)
        }
    }
    
    
    func addNewGroupInfo(extraData: ExtraData) {
        delegate?.retrieveSections([])
        if let currentChild = child {
            var newChild = currentChild
            var infos = currentChild.extraInfo
            infos.append(extraData)
            newChild.extraInfo = infos
            updateChild(newChild: newChild)
        }
    }
    
    func deleteGroupInfo(index: Int) {
        if let currentChild = child {
            var newChild = currentChild
            var infos = currentChild.extraInfo
            infos.remove(at: index)
            newChild.extraInfo = infos
            updateChild(newChild: newChild)
        }
    }
    
    func deleteGroupInfoData(groupIndex: Int, itemIndex: Int) {
        if let currentChild = child {
            var newChild = currentChild
            var infos = currentChild.extraInfo
            var selectedInfo = infos[groupIndex]
            var currentInfos = selectedInfo.infos
            currentInfos.remove(at: itemIndex)
            selectedInfo.infos = currentInfos
            infos[groupIndex] = selectedInfo
            newChild.extraInfo = infos
            updateChild(newChild: newChild)
        }
    }
    
    func editGroupInfoData(groupIndex: Int, itemIndex: Int, item: DetailModel) {
        if let currentChild = child {
            var newChild = currentChild
            var infos = currentChild.extraInfo
            var selectedInfo = infos[groupIndex]
            var currentInfos = selectedInfo.infos
            currentInfos[itemIndex] = item
            selectedInfo.infos = currentInfos
            infos[groupIndex] = selectedInfo
            newChild.extraInfo = infos
            updateChild(newChild: newChild)
        }
    }
    
    func addItemToGroup(groupIndex: Int ,item: DetailModel) {
        if let currentChild = child {
            var newChild = currentChild
            var infos = currentChild.extraInfo
            var selectedInfo = infos[groupIndex]
            var currentInfos = selectedInfo.infos
            currentInfos.append(item)
            selectedInfo.infos = currentInfos
            infos[groupIndex] = selectedInfo
            newChild.extraInfo = infos
            updateChild(newChild: newChild)
        }
    }
    
    
    
    func buildSectionsForInfo() -> [any Section] {
        var sections: [any Section] = []
        if let currentChild = child {
            
            let basicDetails  = ExtraData(
                title: "Informações básicas",
                infos: [
                    DetailModel(name: "Nome", value: currentChild.name),
                    DetailModel(name: "Data de nascimento", value: currentChild.birthDate.formatted()),
                    DetailModel(name: "Sexo", value: currentChild.gender.getGender()?.info ?? "-")
                ])
            
            let footerData: FooterComponent? = if(currentChild.extraInfo.isEmpty) {
                FooterComponent(
                    message: "Adicione informações úteis para cuidar de \(currentChild.name)",
                    actionLabel: "Adicionar informações",
                    messageIcon: nil,
                    actionClosure: { _ in self.delegate?.requestNewGroupInfo() })
            } else {
                nil
            }
            
            let firstDetailSection = SettingsDetailsSection(
                items: basicDetails.infos,
                itemClosure: { detail, view in
                    
                    if(detail == basicDetails.infos.first) {
                        self.delegate?.showEditName(view: view, name: currentChild.name)
                    } else if(detail == basicDetails.infos[1]) {
                        self.delegate?.showEditBirthDate(view: view)
                        
                    } else {
                        self.delegate?.showEditGender(view: view)
                    }
                    
                },
                
                headerData: HeaderComponent(title: basicDetails.title, actionLabel: nil, actionIcon: nil, trailingIcon: nil, actionClosure: nil),
                footerData: footerData,
                headerMenuClosure: { position in })
            
            sections.append(firstDetailSection)
            
            currentChild.extraInfo.map({ data in
                
                SettingsDetailsSection(items: data.infos,
                                       itemClosure: { detail, view in
                    
                    if let groupIndex = currentChild.extraInfo.firstIndex(of: data), let itemIndex = data.infos.firstIndex(of: detail) {
                        self.delegate?.showEditForDetail(groupIndex: groupIndex, itemIndex: itemIndex, item: detail, view: view)
                    }
                },
                                       headerData: HeaderComponent(
                                        title: data.title,
                                        actionLabel: "",
                                        actionIcon: UIImage(systemName: "ellipsis.circle"),
                                        trailingIcon: nil,
                                        actionClosure: nil
                                       ),
                                       footerData: FooterComponent(
                                        message: "",
                                        actionLabel: "Adicionar mais itens",
                                        messageIcon: nil,
                                        actionClosure: { view in
                                            if let groupIndex = currentChild.extraInfo.firstIndex(of: data) {
                                                self.delegate?.requestNewInfo(group: groupIndex, sender: view)
                                            }
                                        }),
                                       headerMenuClosure: { position in self.deleteGroupInfo(index: position - 1) }
                )
                
            }).forEach({ section in
                
                sections.append(section)
                
            })
        }
        return sections
    }
}

extension SettingDetailViewModel: VaccineDetailProtocol {
    
    func buildSectionsForVaccine() -> [VaccineSettingsSection] {
        var sections : [VaccineSettingsSection] = []
        if let currentChild = child {
            let vaccineHelper = VaccineHelper()
            let vaccines = vaccineHelper.groupVaccines(with: currentChild).sorted(by: { firstItem, lastItem in
                
                return firstItem.key == .done
                
            })
            let vaccineSections = vaccines.map({ item in
                let footerData : FooterComponent? = if(item.key == .done) {
                    nil
                } else {
                    FooterComponent(message: "", actionLabel: "Excluir dados", messageIcon: nil, actionClosure: {  _ in self.clearVaccineData() })
                }
                return  VaccineSettingsSection(
                    items: item.value,
                    itemClosure: { vaccine, view in },
                    headerData: HeaderComponent(title: item.key.title, actionLabel: nil, actionIcon: nil, trailingIcon: nil, actionClosure: nil),
                    footerData: footerData)
                
            })
            sections = vaccineSections
        }
        return sections
    }
    
    func clearVaccineData() {
        if let currentChild = child {
            var newChild = currentChild
            newChild.vaccines = []
            updateChild(newChild: newChild)
        }
    }
    
    
}

extension SettingDetailViewModel : DiaperDetailProtocol {
    
    func deleteDiaper(diaper: Diaper) {
        if let currentChild = child {
            if let selectedDiaper = currentChild.diapers.firstIndex(where: { childDiaper in
                
                childDiaper.type == diaper.type
                
            }) {
                var newChild = currentChild
                newChild.diapers.remove(at: selectedDiaper)
                updateChild(newChild: newChild)
            }
        }
    }
    
    func buildSectionsForDiapers() -> [DiaperDetailSection] {
        var sections: [DiaperDetailSection] = []
        if let currentChild = child {
            let diaperMapper = DiaperMapper()
            
            let diaperSections = diaperMapper.mapDiapers(child: currentChild).map({ item in
                
                let size = item.diaper.getSizeType()
                let details = item.linkedActions.map({ action in
                    DetailModel(name: action.description, value: action.formatDate())
                })
                let headerData = HeaderComponent(
                    title: "Fraldas \(size?.description ?? "")",
                    actionLabel: nil, actionIcon: UIImage(systemName: "ellipsis"),
                    trailingIcon: nil,
                    actionClosure: nil
                )
                
                return  DiaperDetailSection(
                    color: item.diaper.getSizeType()?.color ?? UIColor.accent,
                    items: details,
                    itemClosure: { detail, view in },
                    menuClosure: { index in self.deleteDiaper(diaper: item.diaper) },
                    headerData: headerData)
            })
            sections = diaperSections
        }
        return sections
    }
    
    
}

extension SettingDetailViewModel: ActionDetailProtocol {
    
    func deleteActionGroup(actionType: ActionType) {
        
    }
    
    func deleteAction(action: Action) {
        
    }
    
    func buildSectionsForActions() -> [ActionSettingSection] {
        var sections : [ActionSettingSection] = []
        
        if let currentChild = child {
            let actions = ActionType.allCases
            let actionSections = actions.map({ action in
                
                let filteredActions = currentChild.actions.filter({ act in
                    act.type.caseInsensitiveCompare(action.description) == .orderedSame
                })
                let headerData = HeaderComponent(
                    title: action.title,
                    actionLabel: nil,
                    actionIcon: UIImage(systemName: "ellipsis"),
                    trailingIcon: action.cellImage,
                    actionClosure: nil
                )
                
                let footerData = FooterComponent(message: "", actionLabel: "Excluir atividades", messageIcon: nil, actionClosure: {_ in 
                    
                    if var newChild = self.child {
                        newChild.actions = []
                        self.updateChild(newChild: newChild)
                    }
                    
                } )
                let footer: FooterComponent? = if(action == actions.last) { footerData } else { nil }
                return  ActionSettingSection(
                    items: filteredActions,
                    actionType: action,
                    itemClosure: { _, _ in },
                    headerData: headerData,
                    footerData: footer,
                    editingStyle: .delete,
                    menuClosure: { _ in self.deleteActionGroup(actionType: action) }
                )
                
            })
            sections = actionSections.filter({ section in
                !section.items.isEmpty
            })
        }
        
        return sections
    }
    
    
}

extension SettingDetailViewModel: TutorDetailProtocol {
    
    func deleteTutor(index: Int) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.tutors.remove(at: index)
            updateChild(newChild: newChild)
        }
    }
    
    func getTutors() {
        if let currentChild = child {
            let userHelper = UserHelper()
            userHelper.getUsers(ids: currentChild.tutors, with: { tutors in
                DispatchQueue.main.async {
                    self.delegate?.retrieveSections(self.buildSectionsForTutor(tutors: tutors.compactMap({ $0 })))
                }
            } )
        }
    }
    
    
    func buildSectionsForTutor(tutors: [Tutor]) -> [TutorSection] {
        return [TutorSection(items: tutors, itemClosure: { item, view in })]
    }
    
    
}
