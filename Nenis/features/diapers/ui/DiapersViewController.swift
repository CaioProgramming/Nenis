//
//  DiapersViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 22/11/23.
//

import UIKit


protocol DiapersProtocol {
    func addDiaper(diaper: Diaper)
    func deleteDiaper(diaperIndex: Int)
    func updateDiaper(diaper: Diaper, with index: Int)
}
class DiapersViewController: UIViewController {

    static let identifier = "DiapersView"
    var delegate: DiapersProtocol? = nil
    var diapers: [Diaper] = []
    
    @IBOutlet weak var diaperCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        navigationController?.setNavigationBarHidden(false, animated: true)

        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        let collectionCell = DiaperCollectionViewCell()

        diaperCollectionView.register(collectionCell.buildNib(), forCellWithReuseIdentifier: collectionCell.identifier)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height : CGFloat = 150
        return CGSize(width: width, height: width)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let diaper = diapers[indexPath.row]

        
    }
    
 
    
    
}
