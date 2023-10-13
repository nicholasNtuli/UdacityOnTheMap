//
//  MainViewController.swift
//  UdacityOnTheMap
//
//  Created by Sihle Ntuli on 2023/10/13.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityLoadingIndicator: UIActivityIndicatorView!
    
    let signUpUrl = UdacityClient.Endpoints.udacitySignUp.url
    
    var emailFieldIsEmpty = true
    var passwordFieldIsEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        buttonEnabled(false, button: loginButton)
        activityLoadingIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        setLoggingIn(true)
        UdacityClient.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        setLoggingIn(true)
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }
    
    // MARK: Handle login response
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.loginSegue, sender: nil)
            }
        } else {
            showAlert(message: error?.localizedDescription ?? "", title: "Login Error")
        }
    }
    
    // MARK: Loading states
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityLoadingIndicator.startAnimating()
                self.buttonEnabled(false, button: self.loginButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityLoadingIndicator.stopAnimating()
                self.buttonEnabled(true, button: self.loginButton)
            }
        }
        
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    // MARK: Enable and Disable Buttons and Text Fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let currenText = emailTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                emailFieldIsEmpty = true
            } else {
                emailFieldIsEmpty = false
            }
        }
        
        if textField == passwordTextField {
            let currenText = passwordTextField.text ?? ""
            guard let stringRange = Range(range, in: currenText) else { return false }
            let updatedText = currenText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                passwordFieldIsEmpty = true
            } else {
                passwordFieldIsEmpty = false
            }
        }
        
        if emailFieldIsEmpty == false && passwordFieldIsEmpty == false {
            buttonEnabled(true, button: loginButton)
        } else {
            buttonEnabled(false, button: loginButton)
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled(false, button: loginButton)
        if textField == emailTextField {
            emailFieldIsEmpty = true
        }
        if textField == passwordTextField {
            passwordFieldIsEmpty = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonPressed(loginButton)
        }
        
        return true
    }
    
}

