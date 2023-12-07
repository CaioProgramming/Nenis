//
//  DiaperTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 20/11/23.
//

import UIKit

protocol DiaperTableProcol {
    func requestDelete(diaper: Diaper)
    func requestDiscard(diaper: Diaper)
    func requestUpdate(diaper: Diaper)
}
class DiaperTableViewCell: UITableViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    
    
    
    
    var diaperSelectClosure: ((Diaper) -> Void)?
    @IBOutlet weak var diapersCollection: UICollectionView!
    var diapers: [DiaperItem] = []
    var delegate: DiaperTableProcol? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        
        diapersCollection.roundedCorner(radius: 15)
        diapersCollection.register(DiaperCollectionViewCell.buildNib(), forCellWithReuseIdentifier: DiaperCollectionViewCell.identifier)
        diapersCollection.delegate = self
        diapersCollection.dataSource = self
    }
    
    
    func setupDiapers(diapers: [DiaperItem]) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaperCollectionViewCell.identifier, for: indexPath) as! DiaperCollectionViewCell
        cell.setupDiaper(diaper: diaper.diaper, discarded: diaper.linkedActions.count)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let visibleSize = collectionView.visibleSize
        let width = visibleSize.width / 3.5
        let height = visibleSize.height * 0.70
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let diaper = diapers[indexPath.row].diaper
        return getContextualMenu(title: "Opçoes",
                                 actions: [
                                    MenuActions(title: "Adicionar fraldas", image: "plus.diamond.fill", closure: {
                                        self.delegate?.requestUpdate(diaper: diaper)
                                    }),
                                    MenuActions(title: "Descartar fralda", image: "minus.diamond.fill", closure: {
                                        self.delegate?.requestDiscard(diaper: diaper)
                                    }),
                                    MenuActions(title: "Excluir fralda", image: "trash.fill", closure: {
                                        self.delegate?.requestDelete(diaper: diaper)
                                    })
                                 ]
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diaperItem = diapers[indexPath.row].diaper
        if let diaperClosure = diaperSelectClosure {
            diaperClosure(diaperItem)
        }
    }
    
    
}
