//
//  NewActivityViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/09/23.
//

import UIKit

protocol ActivityProtocol: AnyObject {
    func retrieveActivity(activityDescription: Activity)
}

class NewActivityViewController: UIViewController {

    var activtyProtocol: ActivityProtocol?
    var activityType = ActivityType.bath
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var activityTypeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        activityTypeButton.setTitle(activityType.emoji, for: .normal)
        activityTypeButton.menu = UIMenu(
            title: "Atividade do bebê",
            identifier: UIMenu.Identifier(rawValue: "activityMenu"),
            children: getMenuForTypes()
        )
        activityTypeButton.showsMenuAsPrimaryAction = true
        activityTypeButton.changesSelectionAsPrimaryAction = true
        // Do any additional setup after loading the view.
    }
    
    func getMenuForTypes() -> [UIAction] {
        var actions = [UIAction]()
        let activityClosure = {(action: UIAction) in
            self.activityType = self.getActivityForValue(identifier: action.identifier.rawValue)
            self.updateActivityType()
        }
        ActivityType.allCases.forEach({ type in
            actions.append(UIAction(title: type.title, identifier: UIAction.Identifier(type.description),state: .on, handler: activityClosure))
        })
        
        return actions
    }
    
    func updateActivityType() {
        activityTypeButton.setTitle(activityType.emoji, for: .normal)
    }
    
    @IBAction func saveActivityTap(_ sender: UIButton) {
        let text = textField.text
        if(textField.hasText) {
            activtyProtocol?.retrieveActivity(activityDescription: Activity(description: text!, type: activityType, time: Date.now))
            self.dismiss(animated: true)
        }
        
    }
    
    
    func getActivityForValue(identifier: String) -> ActivityType {
        return ActivityType.allCases.first(where: { type in
            type.description == identifier
        }) ?? .bath
    }
    
    @IBAction func textEndEdit(_ sender: UITextField) {
        enableButton(enabled:sender.hasText)
    }
    
    func enableButton(enabled: Bool) {
        saveButton.isEnabled = enabled
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
