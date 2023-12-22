//
//  InputOptionFooterView.swift
//  Nenis
//
//  Created by Caio Ferreira on 04/12/23.
//

import UIKit
import Toast

class InputOptionFooterView: UITableViewHeaderFooterView, CustomViewProtocol {
    static var viewType: ViewType = .footer
    
 
    var saveClosure: ((String, String) -> Void)? = nil
    @IBOutlet weak var fieldTextField: UITextField!

    @IBOutlet weak var containerView: UIView?
    @IBOutlet weak var valueTextField: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView?.roundedCorner(radius: 15)
        self.isHidden = true

    }
    
    func setupFooter(closure: ((String, String) -> Void)?) {

        self.saveClosure = closure
        self.fadeIn()
        addAccessory()
        
    }
    
    private func addAccessory() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(self.saveOption), for: .touchUpInside)
        valueTextField.rightViewMode = UITextField.ViewMode.always
        valueTextField.rightView = button
    }

    @objc func saveOption() {
        guard let field = fieldTextField.validText(), let value = valueTextField.validText(), let closure = saveClosure else {
            Toast.text("Preencha todos os campos para salvar").show()
            return
        }
        closure(field, value)
        fieldTextField.text = ""
        valueTextField.text = ""
        valueTextField.rightView?.isHidden = fieldTextField.validText() != nil && valueTextField.validText() != nil
    }
}

extension InputOptionFooterView: UITextFieldDelegate, UITextInputDelegate {
    
    func selectionWillChange(_ textInput: UITextInput?) {
        
        valueTextField.rightView?.isHidden = fieldTextField.validText() != nil && valueTextField.validText() != nil
        
    }
    
    func selectionDidChange(_ textInput: UITextInput?) {
        valueTextField.rightView?.isHidden = fieldTextField.validText() != nil && valueTextField.validText() != nil
    }
    
    func textWillChange(_ textInput: UITextInput?) {
        valueTextField.rightView?.isHidden = fieldTextField.validText() != nil && valueTextField.validText() != nil
    }
    
    func textDidChange(_ textInput: UITextInput?) {
        valueTextField.rightView?.isHidden = fieldTextField.validText() != nil && valueTextField.validText() != nil
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        valueTextField.rightView?.isHidden = fieldTextField.validText() != nil && valueTextField.validText() != nil
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            valueTextField.rightView?.isHidden = fieldTextField.validText() != nil && valueTextField.validText() != nil
            
        }
    }
}
