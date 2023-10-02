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

class HomeViewController: UIViewController {
    
    
    let homeViewModel = HomeViewModel()
    var authHandler: AuthStateDidChangeListenerHandle? = nil
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var babyActivities: UILabel!
    @IBOutlet weak var emptyBabyView: UIStackView!
    @IBOutlet weak var kidImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var newActionButton: UIButton!
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var child: Child? = nil
    var errorClosure: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.dataSource = self
        activityTable.delegate = self
        homeViewModel.homeDelegate = self
     
        // Do any additional setup after loading the view.
    }
    
    func showError(message: String, buttonMessage: String) {
        loadingIndicator.stopAnimating()
        emptyBabyView.fadeIn()
        errorLabel.text = message
        errorButton.setTitle(buttonMessage, for: .normal)
        activityTable.isHidden = true
        kidImage.isHidden = true
        babyActivities.isHidden = true
        headerView.isHidden = true
        userLabel.isHidden = true
        newActionButton.isHidden = true
        loadingIndicator.isHidden = true
        
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
        if var currentChild = child {
            currentChild.actions.append(newAction)
            homeViewModel.babyService?.updateData(id: child?.id, data: currentChild)
        }
    }
    
    
}

//MARK: - HomeProtocols section
extension HomeViewController: HomeProtocol {
    
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
        childLabel.text = "Resumo do \(child.name)"
        kidImage.clipImageToCircle(color: UIColor.accent)
        kidImage.moa.url = child.photo
        emptyBabyView.fadeOut()
        kidImage.fadeIn()
        babyActivities.fadeIn()
        activityTable.fadeIn()
        headerView.fadeIn()
        userLabel.fadeIn()
        newActionButton.fadeIn()
        self.child = child
        activityTable.reloadData()

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
    
    func sortedActions() -> [Action] {
        if let childActions = child?.actions {
            return childActions.sorted(by: { firstData, secondData in
                firstData.time.compare(secondData.time) == .orderedDescending
            })
        }
        return []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedActions().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activity = sortedActions()[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = activity.description
        cell.detailTextLabel?.textColor = UIColor.placeholderText
        cell.detailTextLabel?.text = formatDate(date: activity.time)
        cell.imageView?.image =  activity.type.cellImage
        cell.imageView?.tintColor = activity.type.imageTint
        
        //        cell.imageView?.backgroundColor = activity.type.imageTint.withAlphaComponent(0.1)
        //        cell.imageView?.layer.masksToBounds = false
        //        cell.imageView?.layer.borderColor =  activity.type.imageTint.cgColor
        //        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height ?? 25.0)/2
        //        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}




