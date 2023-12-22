//
//  NewBabyViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 25/09/23.
//

import UIKit
import UniformTypeIdentifiers
import Toast


class NewChildViewController: UIViewController {

    @IBOutlet weak var babyBirthDatePicker: UIDatePicker!
    @IBOutlet weak var babyImage: UIImageView!
    @IBOutlet weak var babyNameTextField: UITextField!
    var imagePickerController: UIImagePickerController? = nil
    var selectedPhoto: UIImage? = nil
    var childCompletition: ((Child) -> Void )? = nil
    let newBabyViewModel = NewChildViewModel()
    
    
    var currentGender = Gender.boy
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        babyImage.clipImageToCircle(color: currentGender.color)
        babyNameTextField.delegate = self
        newBabyViewModel.delegate = self
        setupDatePicker()
        babyImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openPicker)))
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func genderSelected(_ sender: UISegmentedControl) {
        let gender = Gender.allCases[sender.selectedSegmentIndex]
        currentGender = gender
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InviteViewController {
            destination.inviteDelegate = self
            destination.preferredContentSize = CGSize(width: self.view.frame.width, height: 250)
        }
    }
    
    @IBAction func nameEditEnd(_ sender: UITextField) {
        sender.endEditing(true)
    }
    func updateKidImage(with newPhoto: UIImage) {
        selectedPhoto = newPhoto
        babyImage.image = newPhoto
        babyImage.contentMode = .scaleAspectFill
        babyImage.tintColor = currentGender.color
        babyImage.scaleAnimation(xScale: 1, yScale: 1)
        babyImage.clipImageToCircle(color: currentGender.color)
    }
    
    @objc func openPicker() {
        print("Open image picker")
        babyImage.scaleAnimation(xScale: 0.8, yScale: 0.8)
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
        
        babyImage.scaleAnimation(xScale: 1, yScale: 1)
        
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
        DispatchQueue.main.async {
            Toast.text("Criança salva com sucesso!").show()
             self.dismiss(animated: true)
        }
    }
    
    func errorSaving(errorMessage: String) {
        babyImage.scaleAnimation(xScale: 1, yScale: 1)
        babyImage.showPopOver(viewController: self,message: errorMessage, presentationDelegate: self)
        
    }

}
