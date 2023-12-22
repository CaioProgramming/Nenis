//
//  VaccinesViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import UIKit
import TipKit
import Toast

protocol VaccinesProtocol {
    func updateChild()
}

class VaccinesViewController: UIViewController, VaccineProtocol {
    func showMessage(message: String) {
        Toast.default(image: UIImage(systemName: "syringe.fill")!, title: message).show()

    }
    
    
    func updateData() {
        Toast.default(image: UIImage(systemName: "syringe.fill")!, title: "Vacinas atualizadas com sucesso!").show()
        getVaccines()
    }
    

    static let identifier = "VaccinesView"
    @IBOutlet weak var vaccinesCollection: UICollectionView!
    var vaccines: [(key: Status, value :[VaccineItem])] = []
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
    
    @available(iOS 17.0, *)
    func displayTip() {
        Task { @MainActor in
            let vaccineTip = VaccineTip(delegate: self)

                    for await shouldDisplay in vaccineTip.shouldDisplayUpdates {
                        if shouldDisplay {
                            guard let source = navigationController?.navigationBar else {
                                print("no Source")
                                return
                            }
                            let controller = TipUIPopoverViewController(vaccineTip, sourceItem: source)
                            present(controller, animated: true)
                        } else if presentedViewController is TipUIPopoverViewController {
                            dismiss(animated: true)
                        }
                    }
                }
    }
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 17.0, *) {
            displayTip()
        } else {
            // Fallback on earlier versions
        }
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

extension VaccinesViewController: VaccineTipDelegate {
    func addToCalendar() {
        guard let soonVaccines = vaccines.first(where: {
            $0.key == .soon
        }) else {
            return
        }
        vaccinesViewModel.addAllVacinesToCalendar(vaccines: soonVaccines.value)
    }
    
    
}

extension VaccinesViewController : VaccineUpdateDelegate {
    func addToCalendar(vaccineItem: VaccineItem) {
        self.vaccinesViewModel.addVaccineToCalendar(vaccineItem: vaccineItem)
    }
    
    
    func updateVaccine(vaccination: Vaccination) {
        self.vaccinesViewModel.updateVaccine(newVaccine: vaccination)
    }
    
    
}

extension VaccinesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return vaccines[section].value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = vaccines[indexPath.section]

        switch kind {
          case  UICollectionView.elementKindSectionHeader:
            let headerView =  VaccineCollectionHeaderView.dequeueReusableSupplementaryView(collectionView, at: indexPath)
            headerView.setTitle(with: section.key.title)
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = VaccineFooterView.dequeueReusableSupplementaryView(collectionView, at: indexPath)
            return footerView
        default:
           return UICollectionReusableView()
        }
     
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let section = vaccines[indexPath.section]
        guard section.key != .done else {
            return nil
        }
        let vaccine = section.value[indexPath.row]
        var actions = [MenuActions(title: "Confirmar vaccina",image: "checkmark.circle.fill",
                                   closure: { self.vaccinesViewModel.selectVaccine(vaccineItem: vaccine) }
                                  )]
        if #available(iOS 17.0, *) {
            actions.append(MenuActions(title: "Adicionar ao calendário", image: "calendar", closure: {
                self.vaccinesViewModel.addVaccineToCalendar(vaccineItem: vaccine)
                
            }))
        }
        return getContextualMenu(
            title: "",
            actions: actions
        )
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.contentSize.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if(section == collectionView.numberOfSections - 1) {
            return CGSize(width: collectionView.contentSize.width, height: 100)
        } else {
            return CGSize(width: 0, height: 0)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vaccines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = VaccineVerticalViewCell.dequeueCollectionCell(collectionView, cellForItemAt: indexPath)
        let vaccine = vaccines[indexPath.section].value[indexPath.row]
        cell.setupVaccine(label: vaccine.vaccine.description,vaccine: vaccine.vaccine.title, progress: vaccine.doseProgress  , nextDate: vaccine.formatNextDate(), status: vaccine.status)
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let visibleSize = collectionView.visibleSize
        let width = visibleSize.width / 4
        let height  = visibleSize.height / 4
        return CGSize(width: width, height: height)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vaccine = vaccines[indexPath.section].value[indexPath.row]
        if(vaccine.status != .done) {
            vaccinesViewModel.selectVaccine(vaccineItem: vaccine)
        }
        
    }
    
    
    
 
    
    
}
