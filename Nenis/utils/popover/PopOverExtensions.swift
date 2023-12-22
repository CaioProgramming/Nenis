//
//  PopOverExtensions.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit

extension UIView {
    
    func showPopOver(viewController: UIViewController, message: String, presentationDelegate: UIPopoverPresentationControllerDelegate?, direction: UIPopoverArrowDirection = .any) {
        
        
        let sourceView = self
        let controller = PopOverViewController()
        controller.modalPresentationStyle = .popover
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: sourceView.bounds.width * 0.85, height: 90))
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 10
        label.text = message
        
        controller.addView(label)
        if let popoverPresentationController = controller.popoverPresentationController {
            
            controller.preferredContentSize = CGSize(width: frame.width * 0.80, height: popoverPresentationController.containerView?.wrapHeight() ?? 90)
            
            popoverPresentationController.permittedArrowDirections = direction
            popoverPresentationController.sourceView = sourceView
            popoverPresentationController.sourceRect = self.bounds
            popoverPresentationController.delegate = presentationDelegate
            viewController.present(controller, animated: true)
        }
    }
    
    func showGenderPopOver(viewController: UIViewController, closure: @escaping ((Gender) -> Void), presentationDelegate: UIPopoverPresentationControllerDelegate?, direction: UIPopoverArrowDirection = .any) {
        let sourceView = self
        let controller = GenderMenuViewController()
        controller.modalPresentationStyle = .popover
        if let popoverPresentationController = controller.popoverPresentationController {
            let width = sourceView.frame.size.width / 2
            controller.preferredContentSize = CGSize(width: width, height: sourceView.frame.height)
            popoverPresentationController.permittedArrowDirections = direction
            popoverPresentationController.sourceView = sourceView
            popoverPresentationController.sourceRect = self.bounds
            popoverPresentationController.delegate = presentationDelegate
            controller.setupItems(closure: closure)
            viewController.present(controller, animated: true)
        }
    }
    
    func showInfoIconPopOver(viewController: UIViewController, arrow: UIPopoverArrowDirection = .any, presentationDelegate: UIPopoverPresentationControllerDelegate?, closure: @escaping (String) -> Void) {
        
        let controller = InfoIconViewController()
        let height = CGFloat( 25 * IconOptions.allCases.count)
        controller.preferredContentSize = CGSize(width: frame.width, height: height)
        controller.iconClosure = closure
        controller.modalPresentationStyle = .popover
        
        if let popoverPresentationController = controller.popoverPresentationController {
            
            
            popoverPresentationController.permittedArrowDirections = arrow
            popoverPresentationController.sourceView = self
            popoverPresentationController.sourceRect = self.bounds
            popoverPresentationController.delegate = presentationDelegate
            viewController.present(controller, animated: true)
            
        }
    }
    
    func showDatePopOver(viewController: UIViewController, title: String?, selectedDate: Date = Date(), dateChangeListener: @escaping ((Date) -> Void) ,presentationDelegate: UIPopoverPresentationControllerDelegate?, direction: UIPopoverArrowDirection = .up) {
        let controller = PopOverDatePickerViewController()
        controller.preferredContentSize = CGSize(width: frame.width, height: controller.view.wrapHeight())
        controller.setupView(title: title, closure: dateChangeListener)
        controller.modalPresentationStyle = .popover
        
        if let popoverPresentationController = controller.popoverPresentationController {
            
            
            popoverPresentationController.permittedArrowDirections = direction
            popoverPresentationController.sourceView = self
            popoverPresentationController.sourceRect = self.bounds
            popoverPresentationController.delegate = presentationDelegate
            viewController.present(controller, animated: true)
            
        }
    }
    
    func showInputEditPopOver(fieldInfo: (field: String, editable: Bool), valueInfo: (value: String, editable: Bool), viewController: UIViewController, presentationDelegate: UIPopoverPresentationControllerDelegate?, closure: @escaping (String, String) -> Void) {
        
        
        let controller = SimpleInputViewController()
        controller.preferredContentSize = frame.size
        controller.currentInfo = (fieldInfo: (name: fieldInfo.field, enabled: fieldInfo.editable), valueInfo: (valueInfo.value, enabled: valueInfo.editable))
        
        controller.saveClosure = closure
        
        controller.modalPresentationStyle = .popover
        
        if let popoverPresentationController = controller.popoverPresentationController {
            
            
            popoverPresentationController.permittedArrowDirections = .down
            popoverPresentationController.sourceView = self
            popoverPresentationController.sourceRect = self.bounds
            popoverPresentationController.delegate = presentationDelegate
            viewController.present(controller, animated: true)
            
        }
        
    }
}

extension UIDatePicker {
    func setOnDateChangeListener(onDateChanged :@escaping (Date) -> Void){
        self.addAction(UIAction(){ action in
            
            onDateChanged(self.date)
            
        }, for: .valueChanged)
    }
}
