//
//  NewInfoGroupViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 01/12/23.
//

import UIKit

class NewInfoGroupViewController: UIViewController {
    
    var newInfoClosure: ((ExtraData) -> Void)?
    
    @IBOutlet weak var infosTableView: UITableView!
    @IBOutlet weak var dataTitle: UITextField!
    private var infos: [DetailModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        infosTableView.delegate = self
        infosTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    private func registerCells() {
        let views: [any CustomViewProtocol.Type] = [HorizontalTableViewCell.self, InputOptionFooterView.self]
        views.forEach({ view in
            view.registerTableViewCell(with: infosTableView)
        })
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        sender.configuration?.showsActivityIndicator = true
        guard let closure = newInfoClosure, let title = dataTitle.validText() else {
            
            dataTitle.showPopOver(viewController: self, message: "Informe o título desse grupo de informações,", presentationDelegate: self)
            sender.configuration?.showsActivityIndicator = true
            return
        }
        if(infos.isEmpty) {
            infosTableView.showPopOver(viewController: self, message: "Adicione informações para salvar.", presentationDelegate: self)
        } else {
            self.dismiss(animated: true, completion: {
                closure(ExtraData(title: title, infos: self.infos))
            })
        }
        sender.configuration?.showsActivityIndicator = true

        
    }
    
    private func addInfo(field: String, value: String) {
        infos.append(DetailModel(name: field, value: value))
        infosTableView.reloadData()
    }
    
    private func deleteInfo(index: Int) {
        infos.remove(at: index)
        infosTableView.reloadData()
    }
    
}

extension NewInfoGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let info = infos[indexPath.row]
        let cell = HorizontalTableViewCell.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupData(field: info.name, value: info.value, subtitle: nil, isFirst: info == infos.first, isLast: info == infos.last)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = InputOptionFooterView.dequeueHeaderOrFooter(with: tableView, sectionIndex: section)
        footer.setupFooter(closure: { field, value  in
            self.addInfo(field: field, value: value)
        })
        return footer
           
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteInfo(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 75
    }
    
    
}

extension NewInfoGroupViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}



