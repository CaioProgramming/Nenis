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
import Toast
//MARK: UI SECTION
class HomeViewController: UIViewController {
    
    let homeViewModel = HomeViewModel()
    var authHandler: AuthStateDidChangeListenerHandle? = nil
    var sections: [any Section] = []
    var isViewsRegistered: Bool = false
    @IBOutlet weak var emptyBabyView: UIStackView!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    //@IBOutlet weak var navBar: UINavigationBar!
    var errorClosure: (() -> Void)? = nil
    var iconsCount = 0
    
    
    func setupTableView(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadChild), for: .valueChanged)
        activityTable.dataSource = self
        activityTable.delegate = self
        activityTable.refreshControl = refreshControl
    }
    
    @objc func reloadChild() {
        homeViewModel.initialize()
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
                controller.child = currentChild
                controller.modalPresentationStyle = .overFullScreen
                show(controller, sender: self)
            }
        }
    }
    
    func updateVaccine() {
        if homeViewModel.child != nil {
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
    
    override func viewWillAppear(_ animated: Bool) {
        homeViewModel.initialize()
        startLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.delegate = self
        setupTableView()
       
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    private func startLoading() {
        toggleViews(views: [emptyBabyView, activityTable], isHidden: true)
        if #available(iOS 17.0, *) {
            performIconAnimation()
        } else {
            loadingIndicator.startAnimating()
        }
    }
    
    private func hideLoading() {
        loadingView.fadeOut()
        loadingIndicator.stopAnimating()
        activityTable.refreshControl?.endRefreshing()
    }
    
    @available(iOS 17.0, *)
    func performIconAnimation() {
        loadingView.fadeIn()
        
        delay { [self] in
            if(iconsCount < Option.allCases.count) {
                let option = Option.allCases[iconsCount]
                let icon = option.icon ?? UIImage(named: "bear_color")
                loadingIcon.setSymbolImage(icon!, contentTransition: .replace)
                iconsCount += 1
                performIconAnimation()
            } else {
                loadingIcon.setSymbolImage(UIImage(named: "bear_color")!, contentTransition: .replace)

                loadingIcon.scaleAnimation(xScale: 0, yScale: 0, onCompletion: {
                    self.loadingView.fadeOut()

                })
            }
        }
        
        
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        loadingIndicator.startAnimating()
        sections = []
        homeViewModel.initialize()
    }
    
    
    func showError(message: String, buttonMessage: String) {
        hideLoading()
        errorLabel.text = message
        errorButton.setTitle(buttonMessage, for: .normal)
        emptyBabyView.fadeIn()
    }
    
   
    
    @IBAction func errorClick(_ sender: UIButton) {
        if let closure = errorClosure {
            Logger.init().debug("Calling error closure")
            closure()
        } else {
            Logger.init().warning("Closure not defined!")
            
        }
        
        
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
        guard let child = homeViewModel.child else {
            return
        }
        if let actionDestination = segue.destination as? NewActionViewController {
            
            actionDestination.activtyProtocol = self
            actionDestination.birthDate = child.birthDate
            let validSizes = child.diapers.map({ diaper in
                return diaper.type.getDiaperSizeByDescription() ?? SizeType.RN
            })
            actionDestination.validSizes = validSizes
        }
        
        if let vaccinesDestination = segue.destination as? VaccinesViewController {
            vaccinesDestination.delegate = self
            vaccinesDestination.child = child
        }
        
        if let updateVaccineDestination = segue.destination as? UpdateVaccineViewController {
            updateVaccineDestination.delegate = self
            updateVaccineDestination.info = homeViewModel.vaccineUpdateInfo
        }
      
    }
}

//MARK: -


//MARK: - VaccineProtocols
extension HomeViewController: VaccinesProtocol {
    func updateChild() {
        homeViewModel.initialize()
    }
    
    
}

extension HomeViewController: VaccineUpdateDelegate {
    func addToCalendar(vaccineItem: VaccineItem) {
        homeViewModel.addVaccineToCalendar(vaccineItem: vaccineItem)
    }
    
    func updateVaccine(vaccination: Vaccination) {
        homeViewModel.updateChildVaccine(vaccinate: vaccination)
    }
    
    
    
    
    
}

//MARK: - DiaperCell Protcols sections
extension HomeViewController: DiaperTableProcol {
    
    func requestDelete(diaper: Diaper) {
        self.homeViewModel.deleteDiaper(with: diaper)
    }
    
    func requestDiscard(diaper: Diaper) {        
    }
    
    func requestUpdate(diaper: Diaper) {
        openDiapers()
    }
    
    
}

//MARK: - ActionProtcols section

extension HomeViewController: ActionProtocol {
    
    func retrieveActivity(with newAction: Activity) {
        homeViewModel.addNewAction(action: newAction)
    }
    
    
}

//MARK: - HomeProtocols section
extension HomeViewController: HomeProtocol {
    
    func showMessage(message: String) {
        DispatchQueue.main.async {
            Toast.text(message).show()
        }
    }
    
    
    func openChild(child: Child) {
        let babyStoryBoard = UIStoryboard(name: "Baby", bundle: nil)
        
        let viewController = babyStoryBoard.instantiateViewController(withIdentifier: "ChildSettingsViewController") as! ChildSettingsViewController
        viewController.child = child
        self.show(viewController, sender: self)
    }
    
    
    func confirmVaccine() {
        updateVaccine()
    }
    
    func retrieveHome(with homeSection: [any Section]) {
            
        if(!isViewsRegistered) {
            activityTable.registerSectionsViews(sections: homeSection)
            isViewsRegistered = true
        }
            sections = homeSection
            activityTable.reloadData()
            activityTable.fadeIn()
            hideLoading()
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
        DispatchQueue.main.async { [self] in
            loadingIndicator.stopAnimating()
            parent?.title = child.name
            homeViewModel.buildHomeFromChild(with: child)
        }
        
    }
    
    
    func childNotFound() {
        DispatchQueue.main.async { [self] in
            loadingIndicator.stopAnimating()
            showError(message: "Você não é responsável por nenhuma criança, adicione uma para começar.", buttonMessage: "Adicionar criança")
            errorClosure = {
                self.createNewBaby()
            }
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
        homeViewModel.fetchChild(uid: user.uid)
    }
    
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

//MARK: - TableView Delegates
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        let section = sections[indexPath.section]
        return section.editingStyle
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isChildCell = (cell is ChildTableViewCell)
        if(isChildCell) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isChildCell = (cell is ChildTableViewCell)
        if(isChildCell) {
            navigationController?.setNavigationBarHidden(true, animated: true)
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
        return customSection.dequeueHeader(with: tableView, sectionIndex: section) as? UIView
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customSection = sections[section]
        return customSection.dequeueFooter(with: tableView, sectionIndex: section) as? UIView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        let cell = section.dequeueCell(with: tableView, indexPath: indexPath)
        if(cell is DiaperTableViewCell) {
            if let diaperCell = cell as? DiaperTableViewCell {
                diaperCell.delegate = self
            }
        }
        
        return cell as! UITableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = sections[section]
        return section.footerHeight()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        return section.headerHeight()
    }
    
    
}

