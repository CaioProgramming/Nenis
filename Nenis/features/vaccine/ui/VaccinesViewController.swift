//
//  VaccinesViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import UIKit
import Toast

protocol VaccinesProtocol {
    func updateChild()
}

class VaccinesViewController: UIViewController, VaccineProtocol {
    
    func updateData() {
        Toast.default(image: UIImage(systemName: "syringe.fill")!, title: "Vacinas atualizadas com sucesso!").show()
        getVaccines()
    }
    

    static let identifier = "VaccinesView"
    @IBOutlet weak var vaccinesCollection: UICollectionView!
    var vaccines: [Status : [VaccineItem]] = [:]
    var cells: [any CustomViewProtocol] = [VaccineCollectionViewCell()]
    var child: Child? = nil
    var delegate: VaccinesProtocol? = nil
    let vaccinesViewModel = VaccinesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationController?.setNavigationBarHidden(false, animated: true)
        vaccinesViewModel.delegate = self
        vaccinesViewModel.child = child

        registerCells()
  
        getVaccines()
    }
    
    func getVaccines() {
        if let currentChild = vaccinesViewModel.child {
            vaccines = vaccinesViewModel.loadVaccines(with: currentChild)
            vaccinesCollection.reloadData()
        }
    }
    
    
    func confirmVaccine() {
        performSegue(withIdentifier: "ConfirmVaccine", sender: self)
    }

    func registerCells() {
        vaccinesCollection.delegate = self
        vaccinesCollection.dataSource = self
        
        let collectionCell = VaccineCollectionViewCell()

        vaccinesCollection.register(VaccineCollectionHeaderView.buildNib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VaccineCollectionHeaderView.identifier)
        vaccinesCollection.register(VaccineFooterView.buildNib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: VaccineFooterView.identifier)
        vaccinesCollection.register(VaccineVerticalViewCell.buildNib(), forCellWithReuseIdentifier: VaccineVerticalViewCell.identifier)
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
    
    func updateVaccine(vaccination: Vaccination) {
        self.dismiss(animated: true, completion: {
            self.vaccinesViewModel.updateVaccine(newVaccine: vaccination)
        })
    }
    
    
}

extension VaccinesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = Array(vaccines.keys)[section]
        return vaccines[key]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
          case  UICollectionView.elementKindSectionHeader:
            let headerView =  VaccineCollectionHeaderView.dequeueReusableSupplementaryView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
            
            let key = Array(vaccines.keys)[indexPath.section]
            headerView.setTitle(with: key.title)
                    
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = VaccineFooterView.dequeueReusableSupplementaryView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
            return footerView
        default:
           return UICollectionReusableView()
        }
     
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.contentSize.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if(section == collectionView.numberOfSections - 1) {
            return CGSize(width: collectionView.contentSize.width, height: 150)

        } else {
            return CGSize(width: 0, height: 0)
        }

    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vaccines.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = VaccineVerticalViewCell.dequeueCollectionCell(collectionView, cellForItemAt: indexPath)
        let vaccineGroup = Array(vaccines.keys)[indexPath.section]
        if let vaccine = vaccines[vaccineGroup]?[indexPath.row] {
            cell.setupVaccine(vaccine: vaccine.vaccine.title, progress: vaccine.doseProgress  , nextDate: vaccine.formatDate(), status: vaccine.status)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height : CGFloat = 200
        return CGSize(width: width, height: height)
    
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
