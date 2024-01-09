//
//  SettingDetailViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 30/11/23.
//

import UIKit

 

class SettingDetailViewController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    var child: Child? = nil
    var option: Option? = nil
    var viewModel = SettingDetailViewModel()
    var sections: [any Section] = []
    var navbarButton: UIButton? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.setupDetail(with: child, option: option)
         
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NewInfoGroupViewController {
            controller.newInfoClosure = { data in
                self.viewModel.addNewGroupInfo(extraData: data)
            }
        }
    }
    
    func createNewItem() {
        print("create new item")

    }
    
    @objc func menuButtonTapped() {
        requestNewGroupInfo()
    }

}

extension SettingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.numberOfRows()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       return sections[indexPath.section].editingStyle
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let section = (sections[indexPath.section] as? StatsDataSection) {
            if let deleteClosure = section.deleteClosure {
                deleteClosure(section.items[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sections[indexPath.section].dequeueCell(with: tableView, indexPath: indexPath)
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].dequeueHeader(with: tableView, sectionIndex: section) as? UIView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].dequeueFooter(with: tableView, sectionIndex: section) as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailSection = sections[indexPath.section] as? SettingsDetailsSection {
            let cell = tableView.cellForRow(at: indexPath)
            let item = detailSection.items[indexPath.row]
            detailSection.itemClosure(item, cell)
        }
    }
    
}

extension SettingDetailViewController : DetailProtocol {
    func showEditHeight() {
        let controller = StatusUpdateViewController()
        controller.title = "Atualizar tamanho"
        controller.metricDescription = "cm"
        controller.maxValue = 2.0
        controller.modalPresentationStyle = .automatic
        controller.saveClosure = {
            self.viewModel.updateHeight($0, date: $1)
        }
        present(controller, animated: true)
    }
    
    func showEditWeight() {
        let controller = StatusUpdateViewController()
        controller.title = "Atualizar peso"
        controller.metricDescription = "kg"
        controller.maxValue = 10.0
        controller.modalPresentationStyle = .automatic
        
        controller.saveClosure = {
            self.viewModel.updateWeight($0, date: $1)
        }
        present(controller, animated: true)
    }
    
    func setupNavItem(option: Option) {
        parent?.title = option.title
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = option.title
        
        if(option == .info) {
            navbarButton = UIButton(type: .system)
            navbarButton?.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            navbarButton?.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
            if let barButton = navbarButton {
                self.navigationItem.setRightBarButton(UIBarButtonItem(customView: barButton), animated: true)
            }
        }
         
        
    }
    
    
    func showEditGender(view: UIView?) {
        
        view?.showGenderPopOver(viewController: self, closure: { gender in
        
            self.viewModel.editGender(gender: gender)
        }, presentationDelegate: self, direction: .up)
        
    }
 
    
    
    func showEditName(view: UIView?, name: String) {
        view?.showInputEditPopOver(fieldInfo: ("Nome", false), valueInfo: (name, true), viewController: self, presentationDelegate: self, closure: { field, value in
            self.viewModel.editName(value)
        })
    }
    
    func showEditBirthDate(view: UIView?) {
        view?.showDatePopOver(viewController: self, title: "Data de nascimento", dateChangeListener: { date in
            self.viewModel.editBirthDate(date)
        }, presentationDelegate: self)
    }
    
    
    func requestNewInfo(group: Int, sender: UIView?) {
        sender?.showInputEditPopOver(fieldInfo: ("", true), valueInfo: ("", true), viewController: self, presentationDelegate: self, closure: { field, value in
            self.viewModel.addItemToGroup(groupIndex: group, item: DetailModel(name: field, value: value))
        })
    }
    
    
    func showEditForDetail(groupIndex: Int, itemIndex: Int, item: DetailModel, view: UIView?) {
        
        view?.showInputEditPopOver(fieldInfo: (item.name, true), valueInfo: (item.value, true), viewController: self, presentationDelegate: self, closure: { field, value in
            self.viewModel.editGroupInfoData(groupIndex: groupIndex, itemIndex: itemIndex, item: DetailModel(name: field, value: value))
        })
    }
    
    
    func retrieveSections(_ sections: [any Section]) {
        self.sections = sections
        sections.registerAllSectionsToTableView(detailsTableView)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.reloadData()
        detailsTableView.fadeIn()
    }

    
    func requestNewGroupInfo() {
        performSegue(withIdentifier: "NewInfoSegue", sender: self)
    }
    
    
}

extension SettingDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}


extension SettingDetailViewController : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let actions = Gender.allCases.map({ gender in
            
            MenuActions(title: gender.info, image: nil, closure: {
                self.viewModel.editGender(gender: gender)
            })
        })
       return getContextualMenu(title: "", actions: actions)
    }
    
    
}
