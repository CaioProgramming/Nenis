//
//  InfoIconViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 20/12/23.
//

import UIKit

class InfoIconViewController: UIViewController {

    var iconClosure: ((String) -> ())? = nil
    
    @IBOutlet  private weak var iconCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        
        iconCollectionView.register(IconCollectionViewCell.buildNib(), forCellWithReuseIdentifier: IconCollectionViewCell.identifier)
        // Do any additional setup after loading the view.
    }

 

}

extension InfoIconViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IconOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let icon = IconOptions.allCases[indexPath.row]
        let cell =  IconCollectionViewCell.dequeueCollectionCell(collectionView, cellForItemAt: indexPath)
        cell.setIcon(image: icon.icon, tint: icon.color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.visibleSize.width / 4
        let height = collectionView.visibleSize.height / 2.5
        
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let poupClosure = iconClosure {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.fadeOut(onCompletion: {
                let icon = IconOptions.allCases[indexPath.row]
                poupClosure(icon.description)
                cell?.fadeIn(onCompletion: {
                    self.dismiss(animated: true)
                })
            })
            
        }
    }
}

enum IconOptions: CaseIterable {
    case heart, doctors, pills, development, activities, education
    var description: String { get { return "\(self)".uppercased() } }

    var icon: UIImage? {
        get {
            switch self {
            case .heart:
                UIImage(systemName: "heart.fill")?.withTintColor(color)
            case .doctors:
                UIImage(systemName: "stethoscope")?.withTintColor(color)
            case .pills:
                UIImage(systemName: "pill.fill")?.withTintColor(color)
            case .development:
                UIImage(systemName: "brain.fill")?.withTintColor(color)
            case .activities:
                UIImage(systemName: "shoeprints.fill")?.withTintColor(color)
            case .education:
                UIImage(systemName: "book.pages.fill")?.withTintColor(color)

            }
        }
    }
    
    var color: UIColor {
        get {
            switch self {
            case .heart:
                #colorLiteral(red: 1, green: 0.3570732899, blue: 0.3209906684, alpha: 1)
            case .doctors:
                #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            case .pills:
                #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
            case .development:
                #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
            case .activities:
                #colorLiteral(red: 0.5567079186, green: 0.9848647714, blue: 0.6809157729, alpha: 1)
            case .education:
                #colorLiteral(red: 0.8534491922, green: 0.5999936886, blue: 0.4824235136, alpha: 1)
            }
        }
    }
    
    static func getIconByName(value: String?) -> IconOptions? {
        guard let iconValue = value else {
            return nil
        }
        let icon = IconOptions.allCases.first(where: { option in
        
            option.description.caseInsensitiveCompare(iconValue) == .orderedSame
            
        })
        return icon
    }
}


