//
//  AnimationExtensions.swift
//  Nenis
//
//  Created by Caio Ferreira on 21/09/23.
//

import Foundation
import UIKit


extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        if(!isHidden) {
            print("View is already visible")
            return
        }
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
                          if let complete = onCompletion { complete() }
                       }
        )
    }
    
    func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
                           self.isHidden = true
                           if let complete = onCompletion { complete() }
                       }
        )
    }
    
   
    
    func scaleAnimation(_ duration: TimeInterval = 0.5, xScale: CGFloat, yScale: CGFloat, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransformMakeScale(xScale, yScale)
        }, completion: { (value: Bool) in
            if let complete = onCompletion { complete() }
        })
    }
    
    
    
}
