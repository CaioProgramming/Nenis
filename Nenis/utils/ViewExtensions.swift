//
//  ViewExtensions.swift
//  Nenis
//
//  Created by Caio Ferreira on 26/09/23.
//

import Foundation
import UIKit
import os

extension UIView {
    
    func clipImageToCircle( color: UIColor) {
        self.backgroundColor = color
        self.layer.masksToBounds = false
        self.layer.borderColor =  UIColor.placeholderText.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func roundedCorner(radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func showPopOver(viewController: UIViewController, message: String, presentationDelegate: UIPopoverPresentationControllerDelegate?) {
            
            let utilsStoryBoard = UIStoryboard(name: "Utils", bundle: nil)
             
        
            let sourceView = self
            let controller = utilsStoryBoard.instantiateViewController(withIdentifier: "ErrorPopOver") as? PopOverViewController
            controller?.modalPresentationStyle = .popover
            controller?.message = message
            if let popoverPresentationController = controller?.popoverPresentationController {
                
                controller?.preferredContentSize = CGSize(width: 300, height: 50)

                popoverPresentationController.permittedArrowDirections = .up
                popoverPresentationController.sourceView = sourceView
                popoverPresentationController.sourceRect = self.bounds
                popoverPresentationController.delegate = presentationDelegate
                if let popOverController = controller {
                    viewController.present(popOverController, animated: true)
                }
        }
    }
    
    func createGradientBlur() {
           let gradientLayer = CAGradientLayer()
           gradientLayer.colors = [
           UIColor.white.withAlphaComponent(0).cgColor,
           UIColor.white.withAlphaComponent(1).cgColor]
           let viewEffect = UIBlurEffect(style: .light)
           let effectView = UIVisualEffectView(effect: viewEffect)
           effectView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.size.height, width: self.bounds.width, height: self.bounds.size.height)
           gradientLayer.frame = effectView.bounds
           gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
           gradientLayer.endPoint = CGPoint(x: 0.0 , y: 0.8)
           effectView.autoresizingMask = [.flexibleHeight]
           effectView.layer.mask = gradientLayer
           effectView.isUserInteractionEnabled = false //Use this to pass touches under this blur effect
           addSubview(effectView)

       }
    
}
 
