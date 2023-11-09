//
//  UpdateVaccineViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import UIKit
import os

protocol VaccineUpdateDelegate {
    func updateVaccine(vaccine: Vaccine, newDose: Int)
}

class UpdateVaccineViewController: UIViewController {

    static let identifier = "ConfirmVaccine"
    
    @IBOutlet weak var vaccineSubtitle: UILabel!
    @IBOutlet weak var vaccineMessage: UILabel!
    @IBOutlet weak var vaccineTitle: UILabel!
    var delegate: VaccineUpdateDelegate? = nil
    var info: (Child,  Vaccine, Int)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let confirmInfo = info {
            vaccineTitle.text = String.localizedStringWithFormat(NSLocalizedString("ConfirmVaccineTitle", comment: ""), confirmInfo.1.title)
            vaccineSubtitle.text = String.localizedStringWithFormat(NSLocalizedString("ConfirmVaccineSubtitle", comment: ""), confirmInfo.2, confirmInfo.1.periods.count)
            vaccineMessage.text =  String.localizedStringWithFormat(NSLocalizedString("ConfirmVaccineMessage", comment: ""), confirmInfo.0.name)
        }
        Logger.init().debug("Info -> \(self.info.debugDescription)")
        // Do any additional setup after loading the view.
    }
     


    @IBAction func confirmVaccineTap(_ sender: Any) {
        if let confirmInfo = info {
            delegate?.updateVaccine(vaccine: confirmInfo.1, newDose: confirmInfo.2)
            self.dismiss(animated: true)
        }
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
