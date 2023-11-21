//
//  SignInViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 15/09/23.
//

import UIKit
import Lottie
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class SignInViewController: UIViewController {
    
    var errorMessage: String? = nil
    var isLogin = true
    var authViewModel = AuthViewModel()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpToggleButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var loginButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        authViewModel.authDelegate = self
        hideKeyboardWhenTappedAround()
        userNameTextField.fadeOut()
        animationView.animation = LottieAnimation.named("baby_sleep")
        
        animationView.backgroundColor = UIColor.clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .autoReverse
        animationView.play()
    }
    
    @IBAction func resetPasswordTap(_ sender: UIButton) {
        
        if let emailText = emailTextField.validText() {
            
            authViewModel.resetPassword(email: emailText)
        } else {
            showErrorAlert(with: "Fill your email", anchor: emailTextField)
        }
    }
    
    @IBAction func signWithGoogle(_ sender: UIButton) {
        print("Performing google signIn")
        sender.configuration?.showsActivityIndicator = true
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {  result, error in
            guard error == nil else {
                print(error.debugDescription)
                self.showErrorAlert(with: "Failed to sign with Google")
                sender.configuration?.showsActivityIndicator = false
                return
            }
            
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                self.showErrorAlert(with: "Failed to fetch token")
                sender.configuration?.showsActivityIndicator = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            sender.configuration?.showsActivityIndicator = false
            self.authViewModel.signWithCredentials(with: credential)
        }
    }

    
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func toggleSignUp(_ sender: UIButton) {
        isLogin = !isLogin
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PopOverSegue") {
            let destination = segue.destination as! PopOverViewController
            if let message = errorMessage {
                destination.message = message
            }
        }
    }
    
    func showErrorAlert(with message: String, anchor: UIView? = nil) {
        anchor?.showPopOver(viewController: self, message: message, presentationDelegate: self)
    }
    
    func updateView() {
        
        if(isLogin) {
            userNameTextField.fadeOut()
            self.forgotPassword.fadeIn()

            self.userNameTextField.fadeOut()
            loginButton.setTitle("Login", for: .normal)
            signUpToggleButton.setTitle("Não possui conta? Cadastre-se.", for: .normal)
        } else {
            self.userNameTextField.fadeIn()
            forgotPassword.fadeOut()
            loginButton.setTitle("Cadastrar", for: .normal)
            signUpToggleButton.setTitle("Já possui conta? Fazer Login.", for: .normal)
        }
    }
    
    func toggleLoginButton(hidden: Bool) {
        loginButton.configuration?.showsActivityIndicator = hidden
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
        toggleLoginButton(hidden: true)
        if(isLogin) {
            guard let email = emailTextField.validText(), let password = passwordTextField.validText() else {
                toggleLoginButton(hidden: false)
                showErrorAlert(with: "Empty email/password.")
                return
            }
            authViewModel.loginUser(email: email, password: password)
           
          
        } else {
            guard let email = emailTextField.validText(), let password = passwordTextField.validText(), let user = userNameTextField.validText() else {
                toggleLoginButton(hidden: false)
                showErrorAlert(with: "fill all fields.")
                return
            }
            authViewModel.signUpUser(email: email, password: password, username: user)
        }
    }

    
    
    
    
}
// MARK: - AuthDelegate
extension SignInViewController: AuthProtocol {
    
    func resetPasswordError() {
        showErrorAlert(with: "Error sending reset password message.", anchor: forgotPassword)
    }
    
    func resetPasswordSuccess() {
        showErrorAlert(with: "Password reset message sended.", anchor: forgotPassword)
    }
    
    
    func loginSuccess(userName: String?) {
        toggleLoginButton(hidden: false)
        let alert = UIAlertController(title: "Success!", message: "Welcome \(userName ?? "")", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
             self.dismiss(animated: true)
         }))
         self.present(alert, animated: true)
    }
    
    func loginError() {
        toggleLoginButton(hidden: false)
        let alert = UIAlertController(title: "Unexpected error!", message: "Error making login", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
         }))
         self.present(alert, animated: true)
        showErrorAlert(with: "Error performing login. Try again.")
    }
    
    func signUpError() {
        toggleLoginButton(hidden: false)
        showErrorAlert(with: "Error signing you. Try again.")
    }
    
    func signUpSuccess(userName: String?) {
        toggleLoginButton(hidden: false)
        let alert = UIAlertController(title: "Success!", message: "Welcome \(userName ?? "")", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
             self.dismiss(animated: true)
         }))
         self.present(alert, animated: true)
    }
}

extension SignInViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
