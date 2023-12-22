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
    private var diapers: [DiaperItem] = []
    var diaperViewModel = DiapersViewModel()

    @IBOutlet weak var diapersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)

        diaperViewModel.delegate = self
        diaperViewModel.getDiapers(currentChild: child)
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(menuButtonTapped))
        
        self.navigationItem.setRightBarButton(button, animated: true)
       setupCollectionView()
        // Do any additional setup after loading the view.
    }
    
    @objc func menuButtonTapped() {
        updateDiapers()
    }
    
    private func setupCollectionView() {
        diapersCollectionView.register(DiaperCollectionViewCell.buildNib(), forCellWithReuseIdentifier: DiaperCollectionViewCell.identifier)
        diapersCollectionView.register(CollectionFooterView.buildNib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: CollectionFooterView.identifier)
        diapersCollectionView.delegate = self
        diapersCollectionView.dataSource = self
    }

     
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is UpdateDiaperViewController) {
            let destination = segue.destination as! UpdateDiaperViewController
            destination.delegate = self
            if let selectedDiaper = diaperViewModel.selectedDiaper {
                destination.loadSelectedDiaper(diaper: selectedDiaper)
                
            }
        }
    }
    
    
    func updateDiapers() {
        performSegue(withIdentifier: "updateDiapersSegue", sender: self)
        
    }

}

extension DiapersViewController: UpdateDiaperDelegate {
    
    func deleteDiaper(diaper: Diaper) {
        diaperViewModel.deleteDiaper(diaper: diaper)
    }
    
    
    func retrieveNewDiaper(diaper: Diaper) {
        diaperViewModel.addDiaper(diaper: diaper)
    }
    
    func retrieveUpdatedDiaper(diaper: Diaper) {
        diaperViewModel.updateDiaper(diaper: diaper)
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
        UIView.animate(withDuration: 1.7, animations: { () -> Void in
            cell.alpha = 1
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let diaper = diapers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaperCollectionViewCell.identifier, for: indexPath) as! DiaperCollectionViewCell
        cell.setupDiaper(diaper: diaper.diaper, discarded: diaper.linkedActions.count)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.3
        let height = collectionView.frame.height / 4
        return CGSize(width: width , height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let diaperItem = diapers[indexPath.row]
        self.diaperViewModel.selectDiaper(diaper: diaperItem)
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let diaperItem = diapers[indexPath.row]
        let viewController = ActionsListViewController()
        viewController.setActions(newActions: diaperItem.linkedActions)
        if(diaperItem.linkedActions.isEmpty) {
            viewController.showMessage("Não foram encontradas atividades relacionadas a fralda \(diaperItem.diaper.type)")
        }
        viewController.preferredContentSize = CGSize(width: collectionView.contentSize.width, height: 200)
        viewController.view.backgroundColor = UIColor.clear
        return getContextualMenu(title: "Opções", actions: [
            
            MenuActions(title: "Adicionar fraldas", image: "plus.diamond.fill", closure: {
                self.diaperViewModel.selectDiaper(diaper: diaperItem)
            }),
            MenuActions(title: "Excluir fralda", image: "trash.fill", closure: {
                self.diaperViewModel.deleteDiaper(diaper: diaperItem.diaper)
            })
            
        ], preview: viewController)
    }
    
}

extension DiapersViewController: DiaperProtocol {
    func requestActivity() {
        self.dismiss(animated: true)
    }
    
    
    func retrieveDiapers(diaperItems diapers: [DiaperItem]) {
        self.diapers = diapers
        diapersCollectionView.register(DiaperCollectionViewCell.buildNib(), forCellWithReuseIdentifier: DiaperCollectionViewCell.identifier)
        diapersCollectionView.reloadData()
        if(diapers.isEmpty) {
            navigationController?.navigationBar.showPopOver(viewController: self, message: "Adicione fraldas." , presentationDelegate: self)
        }
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

extension DiapersViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
