//
//  DiaperTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 20/11/23.
//

import UIKit

class DiaperTableViewCell: UITableViewCell, CustomViewProtocol {
    
    var identifier = "DiaperTableViewCell"
    

    var diaperSelectClosure: ((Diaper) -> Void)?
    @IBOutlet weak var diapersCollection: UICollectionView!
    var diapers: [Diaper] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let collectionCell = DiaperCollectionViewCell()

        collectionCell.identifier = DiaperCollectionViewCell().identifier
        diapersCollection.roundedCorner(radius: 15)
        diapersCollection.register(collectionCell.buildNib(), forCellWithReuseIdentifier: collectionCell.identifier)
        diapersCollection.delegate = self
        diapersCollection.dataSource = self
    }

    
    func setupDiapers(diapers: [Diaper]) {
        diapersCollection.roundedCorner(radius: 15)
        self.diapers = diapers
        diapersCollection.reloadData()
    }
    
}

extension DiaperTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let diaper = diapers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaperCollectionViewCell().identifier, for: indexPath) as! DiaperCollectionViewCell
        cell.setupDiaper(diaper: diaper)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 100
        return CGSize(width: 115, height: 150)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diaperItem = diapers[indexPath.row]
        if let diaperClosure = diaperSelectClosure {
            diaperClosure(diaperItem)
        }
    }
    
    
}
