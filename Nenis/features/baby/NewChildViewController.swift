//
//  NewBabyViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 25/09/23.
//

import UIKit
import UniformTypeIdentifiers


class NewChildViewController: UIViewController {

    @IBOutlet weak var babyBirthDatePicker: UIDatePicker!
    @IBOutlet weak var babyImage: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var babyNameTextField: UITextField!
    var imagePickerController: UIImagePickerController? = nil
    var selectedPhoto: UIImage? = nil
    @IBOutlet weak var photoPlaceHolder: UIImageView!
    var childCompletition: ((Child) -> Void )? = nil
    let newBabyViewModel = NewChildViewModel()
    @IBOutlet weak var imageUploadIndicator: UIActivityIndicatorView!
    
    
    var currentGender = Gender.boy
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPicker))
        imageBackground.addGestureRecognizer(tapGesture)
        imageBackground.clipImageToCircle(color: UIColor.systemGray4)
        babyImage.clipImageToCircle(color: Gender.boy.color)
        babyNameTextField.delegate = self
        newBabyViewModel.newChildDelegate = self
        setupDatePicker()
        babyImage.fadeOut()
    }
    
    private func updateGenderUi() {
        
    }
    
    @IBAction func genderSelected(_ sender: UISegmentedControl) {
        let gender = Gender.allCases[sender.selectedSegmentIndex]
        currentGender = gender
        imageBackground.clipImageToCircle(color: currentGender.color)
 
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "InviteSegue") {
            let viewController = segue.destination as! InviteViewController
            viewController.inviteDelegate = self
        }
    }
    
    @IBAction func nameEditEnd(_ sender: UITextField) {
        sender.endEditing(true)
    }
    func updateKidImage(with newPhoto: UIImage) {
        selectedPhoto = newPhoto
        babyImage.image = newPhoto
        babyImage.fadeIn()
        photoPlaceHolder.fadeOut()
        imageBackground.clipImageToCircle(color: currentGender.color)
        imageUploadIndicator.stopAnimating()
    }
    
    @objc func openPicker() {
        print("Open image picker")
        imagePickerController = UIImagePickerController()
        imagePickerController?.delegate = self
        imagePickerController?.mediaTypes = [UTType.image.identifier]
        if let imagePicker = imagePickerController {
            self.show(imagePicker, sender: self)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        errorSaving(errorMessage: "Envie uma foto do seu filho.")
    }
    
    @IBAction func dismissForm(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    func setupDatePicker() {
        babyBirthDatePicker.maximumDate = Date.now
        babyBirthDatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
    }
    
    private func saveChild(sender: UIButton?) {
        guard let babyName = babyNameTextField.validText(), let babyPhoto = selectedPhoto?.jpegData(compressionQuality: 1) else {
            errorSaving(errorMessage: "Some informations are missing")
            return
        }
        newBabyViewModel.saveChild(name: babyName, birthDate: babyBirthDatePicker.date, photoPath: babyPhoto, gender: currentGender.description)
        sender?.configuration?.showsActivityIndicator = true
    }

    @IBAction func saveBabyTouch(_ sender: UIButton) {
     saveChild(sender: sender)
    }


}

extension NewChildViewController : InviteDelegate {
    func childUpdated(child: Child) {
        print("Child updated success")
        saveSuccess(child: child)
    }
    
    
}

extension NewChildViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
}

// MARK: - PopOver Delegate
extension NewChildViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

extension NewChildViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        print(info.debugDescription)
        updateSelectedImage(info: info)
        
    }
    
    func updateSelectedImage(info: [UIImagePickerController.InfoKey : Any]) {
        let photoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let newPhoto = photoImage else {
            errorSaving(errorMessage: "Error getting Image")
            return
        }
        updateKidImage(with: newPhoto)
        imagePickerController?.dismiss(animated: true)
    }
}

extension NewChildViewController: NewChildProtocol {
    func saveSuccess(child: Child) {
        let alert = UIAlertController(title: "Success!", message: "Saved new child as \(child.name)", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
             self.dismiss(animated: true)
             self.saveSuccess(child: child)
         }))
         self.present(alert, animated: true)
    }
    
    func errorSaving(errorMessage: String) {
        babyImage.showPopOver(viewController: self,message: errorMessage, presentationDelegate: self)

    }
    
    
}

