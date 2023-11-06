//
//  VaccineTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import UIKit

class VaccineTableViewCell: UITableViewCell {
    

    static let identifier = "VaccineTableViewCell"
    
    @IBOutlet var collectionView: UICollectionView!
    var vaccines = [String]()
    

    static func nib() -> UINib  {
        return UINib(nibName: VaccineTableViewCell.identifier, bundle: nil)
    }
    
    func updateVaccines(vaccineList : [String]) {
        vaccines = vaccineList
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(VaccineCollectionViewCell.nib(), forCellWithReuseIdentifier: VaccineCollectionViewCell.identifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VaccineCollectionViewCell.identifier, for: indexPath) as! VaccineCollectionViewCell
        let vaccine = vaccines[indexPath.row]
        cell.setupVaccine(vaccine: vaccine, progress: 1, nextDate: "Tommorrow")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 200)
    }
}
