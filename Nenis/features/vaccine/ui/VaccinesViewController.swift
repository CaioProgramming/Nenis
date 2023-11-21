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

class VaccinesViewController: UIViewController, VaccineProtocol {

    static let identifier = "VaccinesView"
    @IBOutlet weak var vaccinesCollection: UICollectionView!
    var vaccines: [Status : [VaccineItem]] = [:]
    var cells: [any CustomViewProtocol] = [VaccineCollectionViewCell()]
    var child: Child? = nil
    var delegate: VaccinesProtocol? = nil
    let vaccinesViewModel = VaccinesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        vaccinesViewModel.delegate = self
        registerCells()
        vaccinesCollection.delegate = self
        vaccinesCollection.dataSource = self
        if let currentChild = child {
            vaccinesViewModel.child = currentChild
            vaccines = vaccinesViewModel.loadVaccines(with: currentChild)
            vaccinesCollection.reloadData()
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func confirmVaccine() {
        performSegue(withIdentifier: "ConfirmVaccine", sender: self)
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }
    func registerCells() {
        let collectionCell = VaccineCollectionViewCell()
        let headerView = VaccineCollectionHeaderView()

        vaccinesCollection.register(headerView.buildNib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerView.identifier)
        vaccinesCollection.register(collectionCell.buildVerticalCell(), forCellWithReuseIdentifier: collectionCell.verticalIdentifier)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == UpdateVaccineViewController.identifier) {
            if let viewController = segue.destination as? UpdateVaccineViewController {
                if let info = vaccinesViewModel.selectedInfo {
                    viewController.delegate = self
                    viewController.info = info
                }
            }
        }
    }
    
    

}

extension VaccinesViewController : VaccineUpdateDelegate {
    
    func updateVaccine(vaccine: Vaccine, newDose: Int) {
        delegate?.updateChildVaccine(newVaccine: Vaccination(vaccine: vaccine.description, dose: newDose))
    }
    
    
}

extension VaccinesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = Array(vaccines.keys)[section]
        return vaccines[key]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        
     
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VaccineCollectionHeaderView().identifier, for: indexPath) as! VaccineCollectionHeaderView
            
        let key = Array(vaccines.keys)[indexPath.section]
        headerView.setTitle(with: key.title)
                
        return headerView
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.contentSize.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vaccines.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VaccineCollectionViewCell().verticalIdentifier, for: indexPath) as! VaccineCollectionViewCell
        let vaccineGroup = Array(vaccines.keys)[indexPath.section]
        if let vaccine = vaccines[vaccineGroup]?[indexPath.row] {
            cell.setupVaccine(vaccine: vaccine.vaccine.title, progress: vaccine.doseProgress  , nextDate: vaccine.formatDate(), status: vaccine.status)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height : CGFloat = 150
        return CGSize(width: width, height: width)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vaccineGroup = Array(vaccines.keys)[indexPath.section]
        if let vaccine = vaccines[vaccineGroup]?[indexPath.row] {
            if(vaccine.status != .done) {
                vaccinesViewModel.selectVaccine(vaccineItem: vaccine)
            }
            
        }
        
    }
    
 
    
    
}
