//
//  SignInViewController.swift
//  Nenis
//
//  Created by Caio Ferreira on 15/09/23.
//

import UIKit

class SignInViewController: UIViewController {
    
    var isLogin = true
    var authViewModel = AuthViewModel()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUpToggleButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        authViewModel.authDelegate = self
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
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
    
    func updateView() {
        userNameTextField.isHidden = !isLogin
        
        if(isLogin) {
            self.userNameTextField.fadeOut()
            loginButton.setTitle("Login", for: .normal)
            signUpToggleButton.setTitle("Não possui conta? Cadastre-se.", for: .normal)
        } else {
            self.userNameTextField.fadeIn()
            loginButton.setTitle("Cadastrar", for: .normal)
            signUpToggleButton.setTitle("Já possui conta? Fazer Login.", for: .normal)
        }
        loginButton.fadeIn()
        
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
        if(isLogin) {
            guard let email = emailTextField.validText(), let password = passwordTextField.validText() else {
                
                print("Empty email/password.")
                return
            }
            authViewModel.loginUser(email: email, password: password)
           
          
        } else {
            guard let email = emailTextField.validText(), let password = passwordTextField.validText(), let user = userNameTextField.validText() else {
                print("fill all fields.")
                return
            }
            authViewModel.signUpUser(email: email, password: password, username: user)
        }
    }
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
}
// MARK: - AuthDelegate
extension SignInViewController: AuthProtocol {
    
    func loginSuccess(userName: String?) {
        let alert = UIAlertController(title: "Success!", message: "Welcome \(userName ?? "")", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
             self.dismiss(animated: true)
         }))
         self.present(alert, animated: true)
    }
    
    func loginError() {
        let alert = UIAlertController(title: "Unexpected error!", message: "Error making login", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
         }))
         self.present(alert, animated: true)
    }
    
    func signUpError() {
        let alert = UIAlertController(title: "Unexpected error!", message: "Error sign up.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
         }))
         self.present(alert, animated: true)
    }
    
    func signUpSuccess(userName: String?) {
        let alert = UIAlertController(title: "Success!", message: "Welcome \(userName ?? "")", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
             alert.dismiss(animated: true)
             self.dismiss(animated: true)
         }))
         self.present(alert, animated: true)
    }
}
