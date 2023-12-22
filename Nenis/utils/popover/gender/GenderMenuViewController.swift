//
//  GenderMenuViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/12/23.
//

import UIKit

class GenderMenuViewController: UIViewController {
    
    
   

    @IBOutlet weak var boyButton: UIButton!
    @IBOutlet weak var girlButton: UIButton!
    var selectClosure: ((Gender) -> Void)? = nil
     override func viewDidLoad() {
        super.viewDidLoad()
         let boyColor = Gender.boy.color
         let girlColor = Gender.girl.color

         boyButton.tintColor = boyColor
         girlButton.tintColor = girlColor
         
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectBoy(_ sender: UIButton) {
        if let closure = selectClosure {
            closure(.boy)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func selectGirl(_ sender: UIButton) {
        if let closure = selectClosure {
            closure(.girl)
            self.dismiss(animated: true)
        }
    }

    
    func setupItems(closure: @escaping ((Gender) -> Void)) {
        self.selectClosure = closure
        
    }
    
    
}
