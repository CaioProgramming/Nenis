//
//  NewActivityViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/09/23.
//

import UIKit

protocol ActivityProtocol: AnyObject {
    func retrieveActivity(activityDescription: String)
}

class NewActivityViewController: UIViewController {

    var activtyProtocol: ActivityProtocol?
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveActivityTap(_ sender: UIButton) {
        var text = textField.text
        if(textField.hasText) {
            activtyProtocol?.retrieveActivity(activityDescription: text ?? "")
            self.dismiss(animated: true)
        }
        
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
