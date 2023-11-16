//
//  HomeViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/09/23.
//

import UIKit
import FirebaseAuth
import moa
import os
//MARK: UI SECTION
class HomeViewController: UIViewController {
    
    let vaccineStoryBoard = "VaccineStoryboard"
    let homeViewModel = HomeViewModel()
    var authHandler: AuthStateDidChangeListenerHandle? = nil
    var sections: [any Section] = []
    @IBOutlet weak var emptyBabyView: UIStackView!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    var errorClosure: (() -> Void)? = nil


    
    func setupTableView(){
        registerTableViews()
        activityTable.dataSource = self
        activityTable.delegate = self
    }
    
    func openVaccines() {
        if let currentChild = homeViewModel.child {
            let storyBoard = UIStoryboard(name: vaccineStoryBoard, bundle: nil)
            if let controller = storyBoard.instantiateViewController(withIdentifier: VaccinesViewController.identifier) as? VaccinesViewController {
                controller.delegate = self
                controller.child = currentChild
                controller.modalPresentationStyle = .overFullScreen
                show(controller, sender: self)
            }
        }
    }
    
    func updateVaccine() {
        if let currentChild = homeViewModel.child {
            let storyBoard = UIStoryboard(name: vaccineStoryBoard, bundle: nil)
            if let controller = storyBoard.instantiateViewController(withIdentifier: UpdateVaccineViewController.identifier) as? UpdateVaccineViewController {
                controller.modalPresentationStyle = .formSheet
                controller.delegate = self
                controller.info = homeViewModel.vaccineUpdateInfo
                present(controller, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        homeViewModel.homeDelegate = self
        setupTableView()
        //activityTable.bounces = false
        //activityTable.isScrollEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    func showError(message: String, buttonMessage: String) {
        loadingIndicator.stopAnimating()
        emptyBabyView.fadeIn()
        errorLabel.text = message
        errorButton.setTitle(buttonMessage, for: .normal)
        toggleViews(views: [activityTable,loadingIndicator], isHidden: true)

        
    }
    
    func toggleViews(views: [UIView], isHidden: Bool) {
        views.forEach({ view in
            view.isHidden = isHidden
        })
    }
    
    @IBAction func errorClick(_ sender: UIButton) {
        if let closure = errorClosure {
            Logger.init().debug("Calling error closure")
            closure()
        } else {
            Logger.init().warning("Closure not defined!")

        }
         
        
    }
    override func viewWillAppear(_ animated: Bool) {
        homeViewModel.initialize()
        loadingIndicator.startAnimating()
    }
    

    
    func signIn() {
        loadingIndicator.startAnimating()
        performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    @objc func performLogin() {
        signIn()
    }
    
    
    @IBAction func createNewActivity(_ sender: UIView) {
        performSegue(withIdentifier: "NewActivitySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewActivitySegue") {
            let destination = segue.destination as! NewActionViewController
            destination.activtyProtocol = self
            if let childDate = homeViewModel.child?.birthDate {
                destination.birthDate = childDate
            }
        } else if (segue.identifier == VaccinesViewController.identifier) {
            if  let destination = segue.destination as? VaccinesViewController {
                destination.delegate = self
                destination.child = homeViewModel.child
            }
        } else if(segue.identifier == UpdateVaccineViewController.identifier) {
            if let destination = segue.destination as? UpdateVaccineViewController {
                destination.delegate = self
                destination.info = homeViewModel.vaccineUpdateInfo
            }
        }
    }
}

//MARK: - VaccineProtocols
extension HomeViewController: VaccinesProtocol {
    func updateChildVaccine(newVaccine: Vaccination) {
        homeViewModel.updateChildVaccine(vaccinate: newVaccine)
    }

    
}

extension HomeViewController: VaccineUpdateDelegate {
    
    func updateVaccine(vaccine: Vaccine, newDose: Int) {
        updateChildVaccine(newVaccine: Vaccination(vaccine: vaccine.description, dose: newDose))
    }
    
    
}

//MARK: - ActionProtcols section

extension HomeViewController: ActionProtocol {
    
    func retrieveActivity(with newAction: Action) {
        homeViewModel.addNewAction(action: newAction)
    }
    
    
}

//MARK: - HomeProtocols section
extension HomeViewController: HomeProtocol {
    
    
    func retrieveHome(with homeSection: [any Section]) {
        sections = homeSection
        Logger.init().info("Sections updated -> \(homeSection.debugDescription)")
        activityTable.reloadData()
    }
    
    
    func createNewBaby() {
        let babyStoryBoard = UIStoryboard(name: "Baby", bundle: nil)
        
        let viewController = babyStoryBoard.instantiateViewController(withIdentifier: "babyViewController") as! NewChildViewController
        viewController.childCompletition = { child in
            self.childRetrieved(with: child)
        }
        self.show(viewController, sender: self)
    }
    
    func childRetrieved(with child: Child) {
        loadingIndicator.stopAnimating()
        navBar.topItem?.title = child.name
    }
    
    
    func childNotFound() {
        loadingIndicator.stopAnimating()
        showError(message: "Você não é responsável por nenhuma criança, adicione uma para começar.", buttonMessage: "Adicionar criança")
        self.errorClosure = {
            self.createNewBaby()
        }
    }
    
    func requireAuth() {
        showError(message: "Faça login para começar a usar o Nenis.", buttonMessage: "Entrar")
        self.errorClosure = {
            self.signIn()
        }
        signIn()
    }
    
    func authSuccess(user: User) {
        emptyBabyView.fadeOut()
    }
    
    
}

//MARK: - TableView Delegates
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func registerTableViews() {
        let cells : [any CustomViewProtocol] = [ ActivityTableViewCell(), VaccineTableViewCell(), ChildTableViewCell()]
        let headers : [any CustomViewProtocol] = [ActionHeaderView(), VaccineHeaderView(), ChildHeaderView()]
        cells.forEach({ view in
            activityTable.register(view.buildNib(), forCellReuseIdentifier: view.identifier)
        })
        headers.forEach({ item in
            activityTable.register(item.buildNib(), forHeaderFooterViewReuseIdentifier: item.identifier)
        })
    }
    

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        let section = sections[indexPath.section]
        
        switch section.type {
        case .actions:
            return .delete
        default:
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let section = sections[section]
        
        if(section.type == .child){
            navBar.fadeOut()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        let section = sections[section]
        
        if(section.type == .child){
            navBar.fadeIn()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete) {
            if sections[indexPath.section] is ActionSection {
                homeViewModel.deleteAction(actionIndex: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = sections[indexPath.section]
        switch section.type {
        case .actions:
          return  75
        case .vaccines:
           return 160
        case .child:
            return 250
        }
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        var rows = 1
        switch section.type {
         
        case .child:
            rows = section.items.count
        case .actions:
           rows = section.items.count
        case .vaccines:
          rows =  1
        }
        return rows
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let headerIdentifier = getHeaderIdentifier(sectionType: section.type)
        switch section.type {
            
        case .actions:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! ActionHeaderView
            header.setupHeader(title: section.title)
            header.buttonAction = { sender in
                self.createNewActivity(sender)
            }
            return header
        case .vaccines:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! VaccineHeaderView
            header.titleLabel.text = section.title
            header.setButtonAction {
                self.openVaccines()
            }
            return header
            
        case .child:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! ChildHeaderView
            if let childSection = section as? ChildSection {
                header.titleLabel.text = childSection.title
                header.subtitleLabel.text = childSection.subtitle
            }
            return header
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        let cellType = getCellIdentifier(sectionType: section.type)
        switch(section.type) {
            
        case .actions:
            if let actionSection = section as? ActionSection {

                let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! ActivityTableViewCell
                let activity = actionSection.items[indexPath.row]
                cell.setupAction(activity: activity, isFirst: indexPath.row == 0, isLast: indexPath.row == (actionSection.items.count - 1))
                return cell
            }
        case .vaccines:
            if let vaccineSection = section as? VaccineSection {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! VaccineTableViewCell
                cell.updateVaccines(vaccineList: vaccineSection.items)
                cell.selectVaccine = { item in
                    self.homeViewModel.selectVaccine(vaccineItem: item)
                    self.updateVaccine()
                }
                 return cell
            }
        case .child:
            if let childSection = section as? ChildSection {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! ChildTableViewCell
                let child = childSection.items[indexPath.row]
                
                cell.childImage.moa.url = child.photo
                
                
                cell.childImage.moa.onSuccess = { image in
                    cell.imageLoadingIndicator.stopAnimating()
                    cell.imageLoadingIndicator.fadeOut()
                    cell.childImage.fadeIn()
                    cell.setupChild(child: child)
                    return image
                }
                return cell
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return  60
    }
    
    func getCellIdentifier(sectionType: SectionType) -> String {
        switch sectionType {
            
        case .actions:
            ActivityTableViewCell().identifier
        case .vaccines:
            VaccineTableViewCell().identifier
        case .child:
            ChildTableViewCell().identifier
        }
    }
    
    func getHeaderIdentifier(sectionType: SectionType) -> String {
        switch sectionType {
        case .actions:
            ActionHeaderView().identifier
        case .vaccines:
            VaccineHeaderView().identifier
        case .child:
            ChildHeaderView().identifier
        }
    }
    
}
