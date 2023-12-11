//
//  ActionsListViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 07/12/23.
//

import UIKit

class ActionsListViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionstableView: UITableView!
    var actions: [Action] = []
    var message: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        actionstableView.delegate = self
        actionstableView.dataSource = self
        actionstableView.register(ActivityTableViewCell.buildNib(), forCellReuseIdentifier: ActivityTableViewCell.identifier)
        // Do any additional setup after loading the view.
    }
 
    func setActions(newActions: [Action]) {
        actions = newActions
    }
    
    func showMessage(_ text: String) {
        self.message = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        actionstableView.reloadData()
        messageLabel.text = message
    }

}


extension ActionsListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let action = actions[indexPath.row]
        let cell = ActivityTableViewCell.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupAction(activity: action, isFirst: action == actions.first, isLast: action == actions.last)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
