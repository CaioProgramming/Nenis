//
//  SimpleInputViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 04/12/23.
//

import UIKit

class SimpleInputViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var saveClosure: ((String, String) -> Void)? = nil
    var currentInfo: (fieldInfo: (name: String, enabled: Bool), valueInfo: (value: String, enabled: Bool))? = nil
    @IBOutlet weak var fieldTextField: UITextField!
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fieldTextField.text = currentInfo?.fieldInfo.name
        fieldTextField.isEnabled = currentInfo?.fieldInfo.enabled ?? true
        valueTextField.text = currentInfo?.valueInfo.value
        valueTextField.isEnabled = currentInfo?.valueInfo.enabled ?? true
        fieldTextField.becomeFirstResponder()
        addAccessory()

    }
    
    private func addAccessory() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
      
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(self.saveOption), for: .touchUpInside)
        valueTextField.rightViewMode = UITextField.ViewMode.always
        valueTextField.rightView = button
    }

    @objc func saveOption(_ sender: UIButton) {
        if #available(iOS 17.0, *) {
            sender.isSymbolAnimationEnabled = true
        } else {
    
        }
        guard let field = fieldTextField.validText(), let value = valueTextField.validText(), let closure = saveClosure else {
            containerView.showPopOver(viewController: self, message: "Todas as informações precisam estar preenchidas",
                                      presentationDelegate: self)
            return
        }
        self.dismiss(animated: true, completion: {
            closure(field, value)
        })
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
