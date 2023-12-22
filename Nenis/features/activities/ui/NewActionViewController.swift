//
//  NewActivityViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/09/23.
//

import UIKit

protocol ActionProtocol: AnyObject {
    func retrieveActivity(with newAction: Activity)
}

class NewActionViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var activtyProtocol: ActionProtocol?
    var activityType = ActionType.bath
    var birthDate: Date?
    var validSizes : [SizeType] = []
    var selectedSize: SizeType? = nil
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var diaperSizeSegment: UISegmentedControl!
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var datePicker: UIDatePicker!
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
        datePicker.maximumDate = Date.now
        if let childDate = birthDate {
            datePicker.minimumDate = childDate
        }
        updateActivityType()
        getSegmentsForDiapers()
        // Do any additional setup after loading the view.
    }
    
    func getSegmentsForDiapers() {
   
        diaperSizeSegment.removeAllSegments()
        if(!validSizes.isEmpty) {
            validSizes.forEach({ size in
                let index = validSizes.firstIndex(of: size)
                diaperSizeSegment.insertSegment(withTitle: size.description, at: index ?? 0, animated: true)
            })
            diaperSizeSegment.selectedSegmentIndex = validSizes.startIndex
            selectedSize = validSizes.first
        }
      
    }
    
    @IBAction func sizeSegmentChange(_ sender: UISegmentedControl) {
        selectedSize = validSizes[sender.selectedSegmentIndex]
    }
    
    func getMenuForTypes() -> [UIAction] {
        let activityClosure = {(action: UIAction) in
            self.activityType = self.getActivityForValue(identifier: action.identifier.rawValue)
            self.updateActivityType()
        }
      return ActionType.allCases.map({ type in
          let menuState = UIMenuElement.State.off
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
        
        if(activityType == .bath) {
            diaperSizeSegment.fadeIn()
        } else {
            diaperSizeSegment.fadeOut()
        }
    }
    
    
    
    @IBAction func saveActivityTap(_ sender: UIButton) {
        let text = textField.text
        if(textField.hasText) {
            activtyProtocol?.retrieveActivity(with: Activity(description: text!, type: activityType.description, time: datePicker.date, usedDiaper: selectedSize?.description))
            self.dismiss(animated: true)
        } else {
            textField.showPopOver(viewController: self, message: "Fill the information", presentationDelegate: self)
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
   
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }

        func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        }

        func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
            return true
        }
    
}
