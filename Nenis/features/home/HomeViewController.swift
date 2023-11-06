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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var emptyBabyView: UIStackView!
    @IBOutlet weak var kidImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var newActionButton: UIButton!
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activitiesView: UIView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var contentScroll: UIScrollView!
    @IBOutlet weak var imageLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var vaccinesView: UIView!
    var errorClosure: (() -> Void)? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTable.register(VaccineTableViewCell.nib(), forCellReuseIdentifier: VaccineTableViewCell.identifier)
        activityTable.register(ActivityTableViewCell.nib(), forCellReuseIdentifier: ActivityTableViewCell.identifier)
        activityTable.dataSource = self
        activityTable.delegate = self
        contentScroll.delegate = self
        //activityTable.bounces = false
        //activityTable.isScrollEnabled = false
        homeViewModel.homeDelegate = self
        // Do any additional setup after loading the view.
    }
    
    func showError(message: String, buttonMessage: String) {
        loadingIndicator.stopAnimating()
        emptyBabyView.fadeIn()
        errorLabel.text = message
        errorButton.setTitle(buttonMessage, for: .normal)
        toggleViews(views: [ activitiesView,
                             headerView,
                             vaccinesView,
                             loadingIndicator,
                            ], isHidden: true)

        
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
    
    func updateUser(withUser: User) {
        userLabel.text = "Olá \(withUser.displayName ?? "cuidador")."
    }
    
    func signIn() {
        loadingIndicator.startAnimating()
        performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    @objc func performLogin() {
        signIn()
    }
    
    
    @IBAction func createNewActivity(_ sender: UIButton) {
        performSegue(withIdentifier: "NewActivitySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewActivitySegue") {
            let destination = segue.destination as! NewActionViewController
            destination.activtyProtocol = self
        }
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
        childLabel.text = child.name
        kidImage.clipImageToCircle(color: child.gender.getGender()?.color ?? UIColor.accent)
        kidImage.moa.onSuccess = { image in
            self.toggleViews(views: [self.imageLoadIndicator], isHidden: true)
            self.kidImage.fadeIn()
            return image
            
        }
        kidImage.moa.url = child.photo
        
        toggleViews(views: [activitiesView,headerView], isHidden: false)
        toggleViews(views: [loadingIndicator, emptyBabyView], isHidden: true)
        let age = child.getAge()
        ageLabel.textColor = child.gender.getGender()?.color ?? UIColor.accent
        //ageLabel.roundedCorner(radius: 10)
        ageLabel.text = age
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
        userLabel.text = "Bem-vindo \(user.displayName ?? "")"
        emptyBabyView.fadeOut()
    }
    
    
}

//MARK: - TableView Delegates
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        var rows = 1
        switch section.type {
            
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        switch(section.type) {
            
        case .actions:
            if let actionSection = section as? ActionSection {
                let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as! ActivityTableViewCell
                let activity = actionSection.items[indexPath.row]
                cell.setupAction(activity: activity)
                return cell
            }
        case .vaccines:
            if let vaccineSection = section as? VaccineSection {
                let cell = tableView.dequeueReusableCell(withIdentifier: VaccineTableViewCell.identifier, for: indexPath) as! VaccineTableViewCell
                cell.updateVaccines(vaccineList: vaccineSection.items)
                 return cell
            }
        }
        return UITableViewCell.init()
    }
    
}
// MARK: ScrollView Delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        navBar.fadeOut()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navBarHidden = (scrollView.contentOffset.y > 50)
        if(navBarHidden) {
            navBar.fadeOut()
        } else {
            navBar.fadeIn()
        }
        
        if scrollView == self.contentScroll {
               //activityTable.isScrollEnabled = (self.contentScroll.contentOffset.y >= 200)
           }

           if scrollView == self.activityTable {
               //self.activityTable.isScrollEnabled = (activityTable.contentOffset.y > 0)
           }
    }
}

// MARK: CHILD EXTENSIONS

extension Child {
    
    func getAge() -> String {
        let calendar = NSCalendar.current
        let birth = self.birthDate
        let currentDate = Date.now
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birth, to: currentDate)
        
        Logger.init().info("Data diff -> \(components.debugDescription)")
        let year = components.year ?? 0
        let weeks = components.weekOfYear ?? 0
        let days = components.day ?? 0
        
        var ageFormatted = ""
        
        if(year > 0) {
            ageFormatted += "\(year) ano"
            if(year > 1) {
                ageFormatted += "s"
            }
        }
        
        if(weeks > 0) {
            ageFormatted += " \(weeks) semana"
            if(weeks > 1) {
                ageFormatted += "s"
            }
        }
        
        if(days > 0) {
            ageFormatted += " \(days) dia"
            if(days > 1) {
                ageFormatted += "s"
            }
        }
            
        
        return ageFormatted
    }
    
}




