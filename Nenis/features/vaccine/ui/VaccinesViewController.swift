//
//  VaccinesViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import UIKit

protocol VaccinesProtocol {
    func updateChildVaccine(newVaccine: Vaccination)
}

class VaccinesViewController: UIViewController {

    static let identifier = "VaccinesView"
    @IBOutlet weak var vaccinesCollection: UICollectionView!
    var vaccines: [VaccineItem] = []
    var cells: [any CustomViewProtocol] = [VaccineCollectionViewCell()]
    var child: Child? = nil
    var delegate: VaccinesProtocol? = nil
    let vaccinesViewModel = VaccinesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        registerCells()
        vaccinesCollection.delegate = self
        vaccinesCollection.dataSource = self
        if let currentChild = child {
            vaccines = vaccinesViewModel.loadVaccines(with: currentChild)
            vaccinesCollection.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }
    func registerCells() {
        var collectionCell = VaccineCollectionViewCell()
        vaccinesCollection.register(collectionCell.buildVerticalCell(), forCellWithReuseIdentifier: collectionCell.verticalIdentifier)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == UpdateVaccineViewController.identifier) {
            if let viewController = segue.destination as? UpdateVaccineViewController {
                if let info = vaccinesViewModel.selectedInfo {
                    viewController.info = info
                    viewController.delegate = self
                }
            }
        }
    }
    
    func confirmVaccine() {
        performSegue(withIdentifier: "ConfirmVaccine", sender: self)
    }

}

extension VaccinesViewController : VaccineUpdateDelegate {
    
    func updateVaccine(vaccine: Vaccine, newDose: Int) {
        delegate?.updateChildVaccine(newVaccine: Vaccination(vaccine: vaccine.description, dose: newDose))
    }
    
    
}

extension VaccinesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vaccines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VaccineCollectionViewCell().verticalIdentifier, for: indexPath) as! VaccineCollectionViewCell
        let vaccine = vaccines[indexPath.row]
        cell.setupVaccine(vaccine: vaccine.vaccine.title, progress: vaccine.doseProgress  , nextDate: vaccine.nextDate, status: vaccine.status)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3
         let height : CGFloat = 175
        return CGSize(width: width, height: height)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vaccineItem = vaccines[indexPath.row]
        if(vaccineItem.status != .done) {
            vaccinesViewModel.selectVaccine(vaccineItem: vaccineItem)
            confirmVaccine()
        }
        
    }
    
 
    
    
}
