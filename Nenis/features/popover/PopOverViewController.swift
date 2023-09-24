//
//  PopOverViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 23/09/23.
//

import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet private weak var messageLabel: UILabel!
    var message: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let popOverMessage = message {
            messageLabel.text = popOverMessage
        }
        // Do any additional setup after loading the view.
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
