//
//  ViewExtensions.swift
//  Nenis
//
//  Created by Caio Ferreira on 26/09/23.
//

import Foundation
import UIKit


extension UIView {
    
    func clipImageToCircle( color: UIColor) {
        self.backgroundColor = color
        
        self.layer.masksToBounds = false
        self.layer.borderColor =  UIColor.placeholderText.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
  
    
}

extension UIViewController {
    
        func showPopOver(with message: String, anchor: UIView, presentationDelegate: UIPopoverPresentationControllerDelegate?) {
            
            let utilsStoryBoard = UIStoryboard(name: "Utils", bundle: nil)
             
        
            let sourceView = anchor
            let controller = utilsStoryBoard.instantiateViewController(withIdentifier: "ErrorPopOver") as? PopOverViewController
            controller?.modalPresentationStyle = .popover
            controller?.message = message
            if let popoverPresentationController = controller?.popoverPresentationController {
                
                controller?.preferredContentSize = CGSize(width: 300, height: 50)

                popoverPresentationController.permittedArrowDirections = .up
                popoverPresentationController.sourceView = sourceView
                popoverPresentationController.sourceRect = anchor.bounds
                popoverPresentationController.delegate = presentationDelegate
                if let popOverController = controller {
                    present(popOverController, animated: true)
                }
        }
    }
}
