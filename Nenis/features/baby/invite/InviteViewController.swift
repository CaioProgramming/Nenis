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
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var selectedChild: Child? = nil
    var inviteDelegate: InviteDelegate? = nil
    
    @IBAction func inviteEdited(_ sender: UITextField) {
        if let inviteID = sender.validText() {
            inviteViewModel.useInvite(inviteID: inviteID)
        }
    }
    
    @IBAction func confirmChildTap(_ sender: UIButton) {
        if let currentChild = selectedChild {
            inviteViewModel.addTutorToChild(with: currentChild)
        }
    }
    
    override func viewDidLoad() {
        inviteViewModel.delegate = self
        kidImage.isHidden = true
        kidName.isHidden = true
        messageLabel.isHidden = true
        confirmButton.isHidden = true
        inviteTextField.delegate = self
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
        inviteDelegate?.childUpdated(child: child)
        self.dismiss(animated: true)
    }
    
    func childRetrieved(child: Child) {
        kidImage.moa.url = child.photo
        kidName.text = child.name
        messageLabel.fadeIn()
        kidImage.fadeIn()
        kidName.fadeIn()
        confirmButton.fadeIn()
        kidImage.clipImageToCircle(color: UIColor.accent)
        selectedChild = child
    }
    
    func childNotFound() {
        showPopOver(with: "Invalid code, please try again.", anchor: inviteTextField, presentationDelegate: self)
    }
    
}
