//
//  TutorsFooterView.swift
//  Nenis
//
//  Created by Caio Ferreira on 19/12/23.
//

import UIKit

class TutorsFooterView: UITableViewHeaderFooterView, CustomViewProtocol {
    static var viewType: ViewType = .footer
    
    @IBOutlet weak var tutorsCollectionView: UICollectionView!
    private var tutors: [Tutor] = []
    
    var footerClosure: (() -> Void)? = nil


    override func awakeFromNib() {
        super.awakeFromNib()
        tutorsCollectionView.dataSource = self
        tutorsCollectionView.delegate = self
        
        tutorsCollectionView.register(TutorCollectionViewCell.buildNib(), forCellWithReuseIdentifier: TutorCollectionViewCell.identifier)
    }
    
    func setupData(tutors: [Tutor], closure: @escaping () -> Void) {
        self.tutors = tutors
        tutorsCollectionView.reloadData()
        self.footerClosure = closure
    }

}

extension TutorsFooterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return if(tutors.count < 4) { tutors.count } else { 4 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tutor = tutors[indexPath.row]
        let cell = TutorCollectionViewCell.dequeueCollectionCell(collectionView, cellForItemAt: indexPath)
        let placeHolder = UIImage(named: "smile.out")
        cell.tutorIcon.loadImage(url: tutor.photoURL, placeHolder: placeHolder, onSuccess: {
            cell.tutorIcon.contentMode = .scaleAspectFill
            cell.clipImageToCircle(color: UIColor.systemBackground)
        }, onFailure: {
            let colors = [UIColor.red, UIColor.link, UIColor.accent, UIColor.magenta, UIColor.systemTeal]
            guard let color = colors.randomElement() else {
                return
            }
            cell.tutorIcon.image = placeHolder
            cell.tutorIcon.contentMode = .scaleAspectFit
            cell.clipImageToCircle(color: color.withAlphaComponent(0.4))
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.visibleSize.width /  5
        let height = collectionView.visibleSize.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let width = collectionView.visibleSize.width /  5

        let totalCellWidth = Int(width) * tutors.count
        let totalSpacingWidth = -25

        let leftInset = (collectionView.visibleSize.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 8, left: leftInset, bottom: 8, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -25
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = footerClosure {
            closure()
        }
    }
    
}
