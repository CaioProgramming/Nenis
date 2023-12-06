//
//  GenderMenuViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/12/23.
//

import UIKit

class GenderMenuViewController: UIViewController {
    
    
    @IBOutlet weak var girlButton: UIButton!
    @IBOutlet weak var boyButton: UIButton!
    var selectClosure: ((Gender) -> Void)? = nil
     override func viewDidLoad() {
        super.viewDidLoad()
         
         girlButton.setTitle(Gender.girl.info, for: .normal)
         girlButton.tintColor = Gender.girl.color
         boyButton.tintColor = Gender.boy.color
         boyButton.setTitle(Gender.boy.info, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func girlTouchInside(_ sender: Any) {
        if let closure = selectClosure {
            closure(Gender.girl)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func boyTouchInside(_ sender: Any) {
        if let closure = selectClosure {
            closure(Gender.boy)
            self.dismiss(animated: true)
        }
    }
    func setupItems(closure: @escaping ((Gender) -> Void)) {
        self.selectClosure = closure
        
    }
    
    
}
