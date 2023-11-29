//
//  VaccineTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import UIKit

class VaccineTableViewCell: UITableViewCell, CustomViewProtocol {
    
    
    @IBOutlet var collectionView: UICollectionView!
    var vaccines = [VaccineItem]()
    var selectVaccine: ((VaccineItem) -> Void)? = nil
    
    
    func updateVaccines(vaccineList : [VaccineItem]) {
        vaccines = vaccineList
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(VaccineCollectionViewCell.buildNib(), forCellWithReuseIdentifier: VaccineCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension VaccineTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vaccines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let vaccineItem = vaccines[indexPath.row]
        return getContextualMenu(
            title: "Opçoes",
            actions: [
                MenuActions(title: "Confirmar vaccina",image: "checkmark.circle.fill",
                            closure: {
                                if let vaccineClosure = self.selectVaccine { vaccineClosure(vaccineItem) }
                            }
                           )
            ]
        )
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VaccineCollectionViewCell.identifier, for: indexPath) as! VaccineCollectionViewCell
        let vaccine = vaccines[indexPath.row]
        cell.setupVaccine(vaccine: vaccine.vaccine.title, progress: vaccine.doseProgress  , nextDate: vaccine.formatDate(), status: vaccine.status)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2
        let height : CGFloat = 75
        return CGSize(width: width, height: height)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vaccineItem = vaccines[indexPath.row]
        if(vaccineItem.status != .done) {
            if let vaccineClosure = selectVaccine {
                vaccineClosure(vaccineItem)
            }
            
        }
    }
    
}
