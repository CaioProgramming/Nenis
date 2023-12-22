//
//  InviteViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 01/10/23.
//

import Foundation
import UIKit

protocol InviteDelegate {
    func childUpdated(child: Child)
}

class InviteViewController: UIViewController {
    
    let inviteViewModel = InviteViewModel()
    @IBOutlet weak var kidName: UILabel!
    @IBOutlet weak var kidImage: UIImageView!
    @IBOutlet weak var inviteTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainContentView: UIStackView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var selectedChild: Child? = nil
    var inviteDelegate: InviteDelegate? = nil
    
    @IBAction func inviteEdited(_ sender: UITextField) {
        if let inviteID = sender.validText() {
            inviteViewModel.useInvite(inviteID: inviteID)
        }
    }
    
    @IBAction func cancelChildTap(_ sender: UIButton) {
        toggleViews(views: [cancelButton, kidImage, kidName, confirmButton, messageLabel], isHidden: true)
        inviteTextField.fadeIn()
    }
    @IBAction func confirmChildTap(_ sender: UIButton) {
        if let currentChild = selectedChild {
            inviteViewModel.addTutorToChild(with: currentChild)
        }
    }
    override func updateViewConstraints() {
                // they're now "cards"
                let TOP_CARD_DISTANCE: CGFloat = 50
                
                let height: CGFloat = self.view.wrapHeight() + TOP_CARD_DISTANCE
           
                view.frame.size.height = height
                // reposition the view (if not it will be near the top)
                view.frame.origin.y = UIScreen.main.bounds.height - height - TOP_CARD_DISTANCE
                view.backgroundColor = UIColor.secondarySystemBackground
                view.roundTopCorners(radius: 15)
                super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        inviteViewModel.delegate = self
        inviteTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kidImage.isHidden = true
        kidName.isHidden = true
        messageLabel.isHidden = true
        confirmButton.isHidden = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
    
    func updateChildData(_ child: Child) {
        kidImage.loadImage(url: child.photo, placeHolder: UIImage(named: "smile.out"), onSuccess: {}, onFailure: {})
        kidName.text = child.name
        messageLabel.fadeIn()
        kidImage.fadeIn()
        kidName.fadeIn()
        confirmButton.fadeIn()
        cancelButton.fadeIn()
        kidImage.clipImageToCircle(color: UIColor.accent)
        selectedChild = child
        inviteTextField.isHidden = true
    }
}

extension InviteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
}

extension  InviteViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        inviteTextField.text = ""
    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

extension InviteViewController: InviteProtcol {
    
    func childUpdated(child: Child) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: {
                self.inviteDelegate?.childUpdated(child: child)
            })
        }
       
    }
    
    func childRetrieved(child: Child) {
        DispatchQueue.main.async {
            self.updateChildData(child)
        }
    }
    
    func childNotFound() {
        DispatchQueue.main.async {
            self.inviteTextField.showPopOver(viewController: self, message: "Invalid code, please try again.", presentationDelegate: self)
        }
    }
    
}
