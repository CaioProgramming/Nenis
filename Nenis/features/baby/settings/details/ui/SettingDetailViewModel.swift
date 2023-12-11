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

class SettingDetailViewModel {
    typealias T = Child
    
    var babyService: BabyService? = nil
    var child: Child? = nil
    var selectedOption: Option? = nil
    var delegate: DetailProtocol? = nil
    
    func setupDetail(with selectedChild: Child?, option: Option?) {
        if(babyService == nil) {
            babyService = BabyService(delegate: self)
        }
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
        default: break
        }
        if let currentOption = selectedOption {
            delegate?.setupNavItem(option: currentOption)

        }
    }
    
    
    
    func buildSectionsForTutors() {
        
    }
    
    func buildSectionsForVaccines() {
        
    }
    
    func buildSectionsForDiapers() {
        
    }
    
    func buildSectionsForActions() {
        
    }
    
}

extension SettingDetailViewModel: DatabaseDelegate {
    
    func updateSuccess(data: Child) {
        self.delegate?.retrieveSections([])
        setupDetail(with: data, option: self.selectedOption)
    }
}


extension SettingDetailViewModel: InfoProtocol {
    
    func editGender(gender: Gender) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.gender = gender.description
            babyService?.updateData(data: newChild)
        }
    }
    
    
    func editName(_ name: String) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.name = name
            babyService?.updateData(data: newChild)
        }
    }
    
    func editBirthDate(_ date: Date) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.birthDate = date
            babyService?.updateData(data: newChild)
        }
    }
    
    
    func addNewGroupInfo(extraData: ExtraData) {
        delegate?.retrieveSections([])
        if let currentChild = child {
            var newChild = currentChild
            var infos = currentChild.extraInfo
            infos.append(extraData)
            newChild.extraInfo = infos
            babyService?.updateData(data: newChild)
        }
    }
    
    func deleteGroupInfo(index: Int) {
        if let currentChild = child {
            var newChild = currentChild
            var infos = currentChild.extraInfo
            infos.remove(at: index)
            newChild.extraInfo = infos
            babyService?.updateData(data: newChild)
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
            babyService?.updateData(data: newChild)
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
            babyService?.updateData(data: newChild)
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
            babyService?.updateData(data: newChild)
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
            
            let footerData: (message: String, actionTitle: String, closure: (UIView?) -> Void)? = if(currentChild.extraInfo.isEmpty) {
                ("Adicione informações úteis para cuidar de \(currentChild.name).", "Adicionar informações", { view in  self.delegate?.requestNewGroupInfo() })
            } else {
                nil
            }
            
            let firstDetailSection = SettingsDetailsSection(
                items: basicDetails.infos,
                headerMenuClosure: { position in },
                itemClosure: { detail, view in
                    
                    if(detail == basicDetails.infos.first) {
                        self.delegate?.showEditName(view: view, name: currentChild.name)
                    } else if(detail == basicDetails.infos[1]) {
                        self.delegate?.showEditBirthDate(view: view)
                        
                    } else {
                        self.delegate?.showEditGender(view: view)
                    }
                    
                },
                headerData: (basicDetails.title, "", nil, { view in }),
                footerData: footerData)
            sections.append(firstDetailSection)
            
            currentChild.extraInfo.map({ data in
                
                SettingsDetailsSection(items: data.infos,
                                       headerMenuClosure: { position in self.deleteGroupInfo(index: position - 1) },
                                       itemClosure: { detail, view in
                    if let groupIndex = currentChild.extraInfo.firstIndex(of: data), let itemIndex = data.infos.firstIndex(of: detail) {
                        self.delegate?.showEditForDetail(groupIndex: groupIndex, itemIndex: itemIndex, item: detail, view: view)
                    }
                },
                                       headerData: (data.title, "", UIImage(systemName: "ellipsis.circle"), { view in }),
                                       footerData: ("", "Adicionar mais itens", { view in
                    if let groupIndex = currentChild.extraInfo.firstIndex(of: data) {
                        self.delegate?.requestNewInfo(group: groupIndex, sender: view)
                    }
                })
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
               let footerData : (message: String, actionTitle: String, closure: (UIView?) -> Void)? = if(item.key == .done) {
                   nil
               } else {
                   ("", "Excluir dados", { view in self.clearVaccineData() })
               }
              return  VaccineSettingsSection(
                    items: item.value,
                    itemClosure: { vaccine, view in },
                    headerData: (item.key.title, "", nil, { view in }),
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
            babyService?.updateData(data: newChild)
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
                babyService?.updateData(data: newChild)
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
             let headerData : (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void) = ("Fraldas \(size?.description ?? "")", "", UIImage(systemName: "ellipsis"), { view in
             
                 
                 
             })
             return  DiaperDetailSection(
                items: details,
                color: item.diaper.getSizeType()?.color ?? UIColor.accent,
                menuClosure: { index in
                 
                 self.deleteDiaper(diaper: item.diaper)
                 
             },
                itemClosure: { detail, view in },
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
           let actionSections = ActionType.allCases.map({ action in
               let filteredActions = currentChild.actions.filter({ act in
                    act.type.caseInsensitiveCompare(action.description) == .orderedSame
                })
                let headerData : (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void) = (title: action.title, actionTitle: "", uiIcon: UIImage(systemName: "ellipsis"), closure: { view in })
                return  ActionSettingSection(
                    items: filteredActions,
                    actionType: action,
                    itemClosure: { _, _ in },
                    headerData: headerData,
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
