//
//  VaccineTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import UIKit

class VaccineTableViewCell: UITableViewCell, CustomViewProtocol {
    static var viewType: ViewType = ViewType.cell
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    var vaccines = [VaccineItem]()
    var selectVaccine: ((VaccineItem, UIView?) -> Void)? = nil
    
    
    func updateVaccines(vaccineList : [VaccineItem]) {
        vaccines = vaccineList
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let size = collectionView.contentSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: size.width/2, height: size.height/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
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
                                if let vaccineClosure = self.selectVaccine { vaccineClosure(vaccineItem, collectionView.cellForItem(at: indexPath)) }
                            }
                           )
            ]
        )
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let vaccine = vaccines[indexPath.row]
        let cell = VaccineCollectionViewCell.dequeueCollectionCell(collectionView, cellForItemAt: indexPath)
        cell.setupVaccine(vaccine: vaccine.vaccine.title, progress: vaccine.doseProgress  , nextDate: vaccine.formatDate(), status: vaccine.status)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.visibleSize.width / 2
        let height : CGFloat = collectionView.visibleSize.height / 2.25
        return CGSize(width: width, height: height)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vaccineItem = vaccines[indexPath.row]
        if(vaccineItem.status != .done) {
            if let vaccineClosure = selectVaccine {
                vaccineClosure(vaccineItem, collectionView.cellForItem(at: indexPath))
            }
            
        }
    }
    
}
