//
//  ChildSettingsViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 29/11/23.
//

import UIKit
import UniformTypeIdentifiers

class ChildSettingsViewController: UIViewController {

    @IBOutlet weak var childTables: UITableView!
    let settingsViewModel = ChildSettingsViewModel()
    var sections: [any Section] = []
    var child: Child? = nil
    var imagePickerController: UIImagePickerController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        settingsViewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentChild = child {
            settingsViewModel.setupChild(child: currentChild)
        }
    }
    
    func showDetailSegue() {
        
        performSegue(withIdentifier: "DetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueController = segue.destination as? SettingDetailViewController {
            segueController.option = settingsViewModel.selectedOption
            segueController.child = settingsViewModel.currentChild
        }
         
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChildSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].dequeueFooter(with: tableView, sectionIndex: section) as? UIView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].dequeueHeader(with: tableView, sectionIndex: section) as? UIView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]        
        let cellView = section.dequeueCell(with: tableView, indexPath: indexPath)
        return cellView as! UITableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.fadeOut(onCompletion: {
            cell?.fadeIn(onCompletion: {
                self.sections[indexPath.section].performItemClosure(index: indexPath.row)
            })
        })
    }
    
}

extension ChildSettingsViewController: SettingsDelegate {
    
    func selectOption(option: Option) {
        showDetailSegue()
    }
    
    func requestUpdatePicture() {
        openPicker()
    }
    
    func retrieveSections(sections: [any Section]) {
        self.sections = []
        childTables.reloadData()
        sections.registerAllSectionsToTableView(childTables)
        childTables.delegate = self
        childTables.dataSource = self
        self.sections = sections
        childTables.reloadData()
    }
    
    func taskError(message: String) {
        print(message)
    }
    
    
}

extension ChildSettingsViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        updateSelectedImage(info: info)
        
    }
    
    @objc func openPicker() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.mediaTypes = [UTType.image.identifier]
        if let imagePicker = imagePickerController {
            self.show(imagePicker, sender: self)
        }
        
    }
    
    func updateSelectedImage(info: [UIImagePickerController.InfoKey : Any]) {
        let photoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let newPhoto = photoImage else {
            print("Error getting Image")
            return
        }
        settingsViewModel.updatePhoto(with: newPhoto)
        imagePickerController?.dismiss(animated: true)
    }
}
