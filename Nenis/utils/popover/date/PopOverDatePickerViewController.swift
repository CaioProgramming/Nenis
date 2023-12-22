//
//  PopOverDatePickerViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/12/23.
//

import UIKit

class PopOverDatePickerViewController: UIViewController {

    @IBOutlet private weak var popDatePicker: UIDatePicker!
    @IBOutlet private weak var titleLabel: UILabel!
    var popTitle: String?
    var dateClosure: ((Date) ->Void)? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func setupView(title: String?, closure: @escaping ((Date) -> Void)){
        self.popTitle = title
        dateClosure = closure
        titleLabel.text = title

    }

    @IBAction func selectDateTap(_ sender: UIButton) {
        if let closure = dateClosure {
            closure(popDatePicker.date)
            self.dismiss(animated: true)
        }
    }

}
