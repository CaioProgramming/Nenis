//
//  TutorCollectionViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 19/12/23.
//

import UIKit

class TutorCollectionViewCell: UICollectionViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    

    
    @IBOutlet weak var tutorIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    

}
