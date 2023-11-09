//
//  VaccineTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import UIKit

class VaccineTableViewCell: UITableViewCell, CustomViewProtocol {
    

    let identifier = "VaccineTableViewCell"
    
    @IBOutlet var collectionView: UICollectionView!
    var vaccines = [VaccineItem]()
    var selectVaccine: ((VaccineItem) -> Void)? = nil

    func nib() -> UINib  {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func updateVaccines(vaccineList : [VaccineItem]) {
        vaccines = vaccineList
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let collectionCell = VaccineCollectionViewCell()
        collectionCell.identifier = VaccineCollectionViewCell.horizontalIdentifier
        collectionView.register(collectionCell.buildNib(), forCellWithReuseIdentifier: collectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension VaccineTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vaccines.count
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VaccineCollectionViewCell().identifier, for: indexPath) as! VaccineCollectionViewCell
        let vaccine = vaccines[indexPath.row]
        cell.setupVaccine(vaccine: vaccine.vaccine.title, progress: vaccine.doseProgress  , nextDate: vaccine.nextDate, status: vaccine.status)
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
