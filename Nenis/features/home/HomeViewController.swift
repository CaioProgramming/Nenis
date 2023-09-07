//
//  HomeViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/09/23.
//

import UIKit

class HomeViewController: UIViewController, ActivityProtocol{
    
    var activities = [String]();
    @IBOutlet weak var activityTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTable.dataSource = self
        activityTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createNewActivity(_ sender: UIButton) {
        performSegue(withIdentifier: "NewActivitySegue", sender: self)
    }
    func retrieveActivity(activityDescription: String) {
        activities.append(activityDescription)
        print("new activity -> \(activityDescription)")
        print(activities.description)
        activityTable.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "NewActivitySegue") {
            let destination = segue.destination as! NewActivityViewController
            destination.activtyProtocol = self
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row -> \(indexPath.row)")
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activity = activities[indexPath.row]
        cell.textLabel?.text = activity
        return cell
    }
}

 
