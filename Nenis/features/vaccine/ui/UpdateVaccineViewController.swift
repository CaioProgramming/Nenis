//
//  UpdateVaccineViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import UIKit
import os

protocol VaccineUpdateDelegate {
    func updateVaccine(vaccination: Vaccination)
    func addToCalendar(vaccineItem: VaccineItem)
}

class UpdateVaccineViewController: UIViewController {

    static let identifier = "ConfirmVaccine"
    
    @IBOutlet weak var vaccineSubtitle: UILabel!
    @IBOutlet weak var vaccineMessage: UILabel!
    @IBOutlet weak var vaccineTitle: UILabel!
    var delegate: VaccineUpdateDelegate? = nil
    var info: (child: Child, item: VaccineItem)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let confirmInfo = info {
            vaccineTitle.text = String.localizedStringWithFormat(NSLocalizedString("ConfirmVaccineTitle", comment: ""), confirmInfo.item.vaccine.title)
            vaccineSubtitle.text = String.localizedStringWithFormat(NSLocalizedString("ConfirmVaccineSubtitle", comment: ""), (confirmInfo.item.nextDose + 1), confirmInfo.item.vaccine.periods.count)
            vaccineMessage.text =  String.localizedStringWithFormat(NSLocalizedString("ConfirmVaccineMessage", comment: ""), confirmInfo.0.name)
        }
        Logger.init().debug("Info -> \(self.info.debugDescription)")
        // Do any additional setup after loading the view.
    }
    
     
    func updateInfo(newInfo: (Child,  VaccineItem)) {
        info = newInfo
    }


    @IBAction func confirmVaccineTap(_ sender: Any) {
        if let confirmInfo = info {
            self.dismiss(animated: true, completion: {
                self.delegate?.updateVaccine(vaccination: Vaccination(vaccine: confirmInfo.item.vaccine.description, dose: confirmInfo.item.nextDose + 1))
            })

        }
    }
    
    @IBAction func addVaccineToCalendar(_ sender: UIButton) {
        guard let vaccineInfo = info else {
            return
        }
        self.delegate?.addToCalendar(vaccineItem: vaccineInfo.item)
        self.dismiss(animated: true)
    }
  

}
