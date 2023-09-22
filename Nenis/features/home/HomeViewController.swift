//
//  HomeViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/09/23.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, ActivityProtocol, FUIAuthDelegate {
    
    var activities = [Action]();
    let homeViewoModel = HomeViewModel()
    var authHandler: AuthStateDidChangeListenerHandle? = nil
    @IBOutlet weak var kidImage: UIImageView!
    @IBOutlet weak var activityTable: UITableView!
    var user: User? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.dataSource = self
        activityTable.delegate = self
      
        clipImage(uiImage: kidImage, color: UIColor.tintColor)
        //signIn()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(performLogin))
        kidImage.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      authHandler = Auth.auth().addStateDidChangeListener{ auth, user in
            if(user == nil) {
                self.signIn()
            } else {
                self.updateUser(withUser: user!)
            }
        }
    }

    func updateUser(withUser: User) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if authHandler != nil {
            Auth.auth().removeStateDidChangeListener(authHandler!)

        }
    }
    
    func signIn() {
        performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    @objc func performLogin() {
        signIn()
    }
    
    
    @IBAction func createNewActivity(_ sender: UIButton) {
        performSegue(withIdentifier: "NewActivitySegue", sender: self)
    }
    func retrieveActivity(activityDescription: Action) {
        activities.append(activityDescription)
        print("new activity -> \(activityDescription)")
        print(activities.description)
        activities.sort(by: { firstData, secondData in
            
            firstData.time.compare(secondData.time) == .orderedDescending
            
        })
        activityTable.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewActivitySegue") {
            let destination = segue.destination as! NewActionViewController
            destination.activtyProtocol = self
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row -> \(indexPath.row)")
    }
}

func clipImage(uiImage: UIImageView, color: UIColor) {
    uiImage.backgroundColor = color
    uiImage.layer.masksToBounds = false
    uiImage.layer.borderColor =  UIColor.placeholderText.cgColor
    uiImage.layer.cornerRadius = uiImage.frame.height / 2
    uiImage.clipsToBounds = true
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activity = activities[indexPath.row]
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

 

 
