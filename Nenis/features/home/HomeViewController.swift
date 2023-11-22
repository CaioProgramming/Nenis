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
    
    let homeViewModel = HomeViewModel()
    var authHandler: AuthStateDidChangeListenerHandle? = nil
    var sections: [any Section] = []
    @IBOutlet weak var emptyBabyView: UIStackView!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //@IBOutlet weak var navBar: UINavigationBar!
    var errorClosure: (() -> Void)? = nil
    
    
    
    func setupTableView(){
        registerTableViews()
        activityTable.dataSource = self
        activityTable.delegate = self
    }
    
    func showVaccines() {
        if let currentChild = homeViewModel.child {
            let vaccineStoryBoard = "VaccineStoryboard"
            let storyBoard = UIStoryboard(name: vaccineStoryBoard, bundle: nil)
            if let controller = storyBoard.instantiateViewController(withIdentifier: VaccinesViewController.identifier) as? VaccinesViewController {
                controller.delegate = self
                controller.child = currentChild
                controller.modalPresentationStyle = .overFullScreen
                show(controller, sender: self)
            }
        }
    }
    
    func showDiapers() {
        if let currentChild = homeViewModel.child {
            let storyBoardIdentifier = "DiaperStoryboard"
            let storyBoard = UIStoryboard(name: storyBoardIdentifier, bundle: nil)
            if let controller = storyBoard.instantiateViewController(withIdentifier: DiapersViewController.identifier) as? DiapersViewController {
                controller.delegate = self
                controller.diapers = currentChild.diapers
                controller.modalPresentationStyle = .overFullScreen
                show(controller, sender: self)
            }
        }
    }
    
    func updateVaccine() {
        if let currentChild = homeViewModel.child {
            let vaccineStoryBoard = "VaccineStoryboard"
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
        homeViewModel.sectionDelegate = self
        setupTableView()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
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
    
    
     func createNewActivity() {
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

//MARK: - DiaperProtocols
extension HomeViewController: DiapersProtocol {
    
    func updateDiaper(diaper: Diaper, with index: Int) {
        
        homeViewModel.updateDiaper(with: diaper, index: index)

    }
    
    
    func addDiaper(diaper: Diaper) {
        homeViewModel.addDiaper(with: diaper)
    }
    
    func deleteDiaper(diaperIndex: Int) {
        homeViewModel.deleteDiaper(with: diaperIndex)
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
        parent?.title = child.name
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
        let cells : [any CustomViewProtocol] = [ ActivityTableViewCell(), VaccineTableViewCell(), ChildTableViewCell(), DiaperTableViewCell()]
        let headers : [any CustomViewProtocol] = [ActionHeaderView(), VaccineHeaderView(), ChildHeaderView(), DiaperHeaderView()]
        cells.forEach({ view in
            activityTable.register(view.buildNib(), forCellReuseIdentifier: view.identifier)
        })
        headers.forEach({ item in
            activityTable.register(item.buildNib(), forHeaderFooterViewReuseIdentifier: item.identifier)
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        let section = sections[indexPath.section]
        if(section is ActionSection) {
            return .delete
        } else {
            return .none
        }
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isChildCell = (cell is ChildTableViewCell)
        navigationController?.setNavigationBarHidden(isChildCell, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isChildCell = (cell is ChildTableViewCell)
        navigationController?.setNavigationBarHidden(!isChildCell, animated: true)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete) {
            if sections[indexPath.section] is ActionSection {
                homeViewModel.deleteAction(actionIndex: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return sections[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customSection = sections[section]
        return customSection.dequeueHeader(with: tableView, sectionIndex: section)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        return section.dequeueCell(with: tableView, indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        return section.headerHeight
    }
    
    
}

//MARK: SECTIONS DELEGATES
extension HomeViewController: SectionsProtocol {
    
    func requestNewAction() {
        createNewActivity()
    }
    
    func openVaccines() {
        showVaccines()
    }
    
    func openDiapers() {
        showDiapers()
    }
}
