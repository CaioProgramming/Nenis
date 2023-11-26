//
//  DiapersViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 22/11/23.
//

import UIKit
import Toast


protocol DiapersProtocol {
    func addDiaper(diaper: Diaper)
    func deleteDiaper(diaperIndex: Int)
    func updateDiaper(diaper: Diaper, with index: Int)
}
class DiapersViewController: UIViewController {

    static let identifier = "DiapersView"
    var delegate: DiapersProtocol? = nil
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
        // Do any additional setup after loading the view.
    }
    
    
    func registerCells() {
        diaperCollectionView.delegate = self
        diaperCollectionView.dataSource = self
        let collectionCell = DiaperCollectionViewCell()
        let footerView = DiaperFooterCollectionReusableView()
        diaperCollectionView.register(collectionCell.buildNib(), forCellWithReuseIdentifier: collectionCell.identifier)
        diaperCollectionView.register(footerView.buildNib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerView.identifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is UpdateDiaperViewController) {
            let destination = segue.destination as! UpdateDiaperViewController
            destination.delegate = self
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
        if let index = diapers.firstIndex(where: { childDiaper in
        
            childDiaper == diaper
        }) {
            diaperViewModel?.deleteDiaper(position: index)

        }
    }
    
    
    func retrieveNewDiaper(diaper: Diaper) {
        diaperViewModel?.addDiaper(diaper: diaper)
    }
    
    func retrieveUpdatedDiaper(diaper: Diaper) {
        diaperViewModel?.updateDiaper(diaper: diaper)
    }
    
    
}


extension DiapersViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return diapers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = DiaperCollectionViewCell()
        let diaper = diapers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCell.identifier, for: indexPath) as! DiaperCollectionViewCell
        cell.setupDiaper(diaper: diaper)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
           let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DiaperFooterCollectionReusableView().identifier, for: indexPath) as! DiaperFooterCollectionReusableView
               
        footerView.footerClosure = {
            self.updateDiapers()
        }
                   
           return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.5
        let height : CGFloat = collectionView.frame.height / 3
        return CGSize(width: width , height: height)
        
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let diaper = diapers[indexPath.row]

        
    }

}

extension DiapersViewController: DiaperProtocol {
    
    func retrieveDiapers(diapers: [Diaper]) {
        self.diapers = diapers
        emptyView.fadeOut()
        diaperCollectionView.reloadData()
    }
    
    func noDiapersFound() {
        emptyView.fadeIn()
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
