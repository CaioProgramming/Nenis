//
//  SettingDetailViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 30/11/23.
//

import Foundation

protocol DetailProtocol {
    func retrieveSections(_ sections :[any Section])
    func retrieveNewInfo(extraData: ExtraData)
    func requestNewInfo()
    
}

class SettingDetailViewModel {
    
    var child: Child? = nil
    var delegate: DetailProtocol? = nil
    
   func setupDetail(with selectedChild: Child?, option: Option?) {
        child = selectedChild
        if(option == .info) {
           buildSectionsForInfo()
       }
    }
    
    func buildSectionsForInfo() {
        if let currentChild = child {
            var details = [ExtraData(title: "Informaçoes basicas", infos: [DetailModel(name: "Nome", value: currentChild.name), DetailModel(name: "Data de nascimento", value: currentChild.birthDate.formatted())])]
            
            currentChild.extraInfo.forEach({ detail in
                details.append(detail)
            })
            
            let sections = details.map({ data in
                SettingsDetailsSection(items: data.infos, itemClosure: { detail in } ,headerData: (data.title, "", nil, {}), footerData: ("", "Adicionar mais itens", { self.delegate?.requestNewInfo() }))
                
            })
            delegate?.retrieveSections(sections)
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
