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
    
    func roundTopCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func roundBottomCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    
    
    func dropShadow(scale: Bool = true, oppacity: Float = 0.5, radius: CGFloat = 5, color: UIColor?) {
            layer.masksToBounds = false
            layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
            layer.shadowOpacity = oppacity
            layer.shadowOffset = .zero
            layer.shadowRadius = radius
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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
    
    func setGradientBackground(colors: [UIColor]) {
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map({ color in
            color.cgColor
        })
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func wrapHeight() -> CGFloat {
        
        // calculate height of everything inside that stackview
        var height: CGFloat = 0.0
        for v in subviews {
            height = height + v.frame.size.height
        }
        
        // change size of Viewcontroller's view to that height
        return height
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    func getPositionConstraint(attribute: NSLayoutConstraint.Attribute) -> Int? {
        let constraint = constraints.firstIndex(where: { constraint in
        
            constraint.firstAttribute == attribute && constraint.relation == .equal
        })
        return constraint
    }

}

struct MenuActions {
    let title: String
    let image: String?
    let closure: () -> Void
}

func getContextualMenu(title: String, actions: [MenuActions], preview: UIViewController? = nil) -> UIContextMenuConfiguration {
    
    let uiActions = actions.map({ element in
        UIAction(title: element.title, image: UIImage(systemName: element.image ?? ""), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
            element.closure()
        }
    })
    
    let context = UIContextMenuConfiguration(identifier: nil, previewProvider: {
        return preview
    }) { (action) -> UIMenu? in
        
        return UIMenu(title: title, image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: uiActions)

    }
    return context
}

extension UITableView {
    func registerSectionsViews(sections: [any Section]) {
        
        
        
        sections.map({ section in
            section.getUIComponents()
        }).forEach({ components in
        
            components.forEach({ component in
            
                switch component.viewType {
                    
                case .cell, .reusableView:
                    self.register(component.nib, forCellReuseIdentifier: component.identifier)
                case .header, .footer:
                    self.register(component.nib, forHeaderFooterViewReuseIdentifier: component.identifier)
                }
            })
        })
    }
}



extension UIImageView {
    
    func loadImage(url: String?, placeHolder: UIImage?, onSuccess: @escaping () -> (), onFailure: @escaping () -> ()) {
        sd_setImage(with: URL(string: url ?? ""),placeholderImage: placeHolder, completed: { image, error ,_,_ in
        
            guard let image else {
                onFailure()
                return
            }
            onSuccess()
        })
    }
    
}
