//
//  PopOverViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 23/09/23.
//

import UIKit

class PopOverViewController: UIViewController {

    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    func addView(_ view: UIView) {
        self.view.addSubview(view)
    }
}
