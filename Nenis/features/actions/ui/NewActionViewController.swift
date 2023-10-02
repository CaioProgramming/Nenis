//
//  NewActivityViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/09/23.
//

import UIKit

protocol ActionProtocol: AnyObject {
    func retrieveActivity(with newAction: Action)
}

class NewActionViewController: UIViewController {

    var activtyProtocol: ActionProtocol?
    var activityType = ActionType.bath
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var activityTypeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTypeButton.menu = UIMenu(
            title: "Atividade do bebê",
            identifier: UIMenu.Identifier(rawValue: "activityMenu"),
            children: getMenuForTypes()
        )
        activityTypeButton.showsMenuAsPrimaryAction = true
        activityTypeButton.changesSelectionAsPrimaryAction = true
        updateActivityType()
        // Do any additional setup after loading the view.
    }
    
    
    func getMenuForTypes() -> [UIAction] {
        let activityClosure = {(action: UIAction) in
            self.activityType = self.getActivityForValue(identifier: action.identifier.rawValue)
            self.updateActivityType()
        }
      return ActionType.allCases.map({ type in
          var menuState = UIMenuElement.State.off
          return UIAction(
                        title: type.title,
                          identifier: UIAction.Identifier(type.description),
                          state: menuState,
                          handler: activityClosure)
        })
    }
    
    func updateActivityType() {
        activityTypeButton.setTitle("\(activityType.emoji) \(activityType.title)", for: .normal)
        activityTypeButton.tintColor = activityType.imageTint
    }
    
    @IBAction func saveActivityTap(_ sender: UIButton) {
        let text = textField.text
        if(textField.hasText) {
            activtyProtocol?.retrieveActivity(with: Action(description: text!, type: activityType, time: Date.now))
            self.dismiss(animated: true)
        }
        
    }
    
    
    func getActivityForValue(identifier: String) -> ActionType {
        return ActionType.allCases.first(where: { type in
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
