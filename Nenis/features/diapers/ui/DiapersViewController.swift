//
//  DiapersViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 22/11/23.
//

import UIKit
import Toast


class DiapersViewController: UIViewController {
    
    static let identifier = "DiapersView"
    var child: Child? = nil
    private var diapers: [Diaper] = []
    var diaperViewModel : DiapersViewModel? = nil
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var diaperCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        registerCells()
        diaperViewModel = DiapersViewModel()
        diaperViewModel?.delegate = self
        diaperViewModel?.getDiapers(currentChild: child)
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        self.navigationItem.setRightBarButton(button, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func menuButtonTapped() {
        updateDiapers()
    }

    func registerCells() {
        diaperCollectionView.register(DiaperCollectionViewCell.buildNib(), forCellWithReuseIdentifier: DiaperCollectionViewCell.identifier)
        diaperCollectionView.register(CollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionFooterView.identifier)
        diaperCollectionView.delegate = self
        diaperCollectionView.dataSource = self
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is UpdateDiaperViewController) {
            let destination = segue.destination as! UpdateDiaperViewController
            destination.delegate = self
            if let selectedDiaper = diaperViewModel?.selectedDiaper {
                destination.loadSelectedDiaper(diaper: selectedDiaper)
                
            }
        }
    }
    
    
    func updateDiapers() {
        performSegue(withIdentifier: "updateDiapersSegue", sender: self)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DiapersViewController: UpdateDiaperDelegate {
    
    func deleteDiaper(diaper: Diaper) {
        diaperViewModel?.deleteDiaper(diaper: diaper)
    }
    
    
    func retrieveNewDiaper(diaper: Diaper) {
        diaperViewModel?.addDiaper(diaper: diaper)
    }
    
    func retrieveUpdatedDiaper(diaper: Diaper) {
        diaperViewModel?.updateDiaper(diaper: diaper)
    }
    
    func updateDiaper() {
        updateDiapers()
    }
    
}


extension DiapersViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return diapers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.fadeIn()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let diaper = diapers[indexPath.row]
        let cell = DiaperCollectionViewCell.dequeueCollectionCell(collectionView, cellForItemAt: indexPath)
        cell.setupDiaper(diaper: diaper)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionFooterView.identifier, for: indexPath) as! CollectionFooterView
           
           footerView.footerClosure = {
               self.updateDiapers()
           }
            return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.3
        let height = collectionView.frame.height / 4
        return CGSize(width: width , height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let diaper = diapers[indexPath.row]
        self.diaperViewModel?.selectDiaper(diaper: diaper)
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let diaper = diapers[indexPath.row]
        return getContextualMenu(title: "Opçoes", actions: [
            
            MenuActions(title: "Adicionar fraldas", image: "plus.diamond.fill", closure: {
                self.diaperViewModel?.selectDiaper(diaper: diaper)
            }),
            MenuActions(title: "Descartar fralda", image: "minus.diamond.fill", closure: {
                self.diaperViewModel?.discardDiaper(diaper: diaper)
            }),
            MenuActions(title: "Excluir fralda", image: "trash.fill", closure: {
                self.diaperViewModel?.deleteDiaper(diaper: diaper)
            })
            
        ])
    }
    
}



extension DiapersViewController: DiaperProtocol {
    
    func retrieveDiapers(diapers: [Diaper]) {
        self.diapers = diapers
        diaperCollectionView.reloadData()
    }
    
    
    func diaperUpdated(message: String) {
        let toast = Toast.text("Fraldas atualizadas com sucesso")
        toast.show()
        
    }
    
    func errorUpdating(message: String) {
        let toast = Toast.text("Ocorreu um erro inesperado ao atualizar. (\(message)")
        toast.show()
    }
    
    
}
