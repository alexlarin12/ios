//
//  RegistrationViewController.swift
//  NextSwift
//
//  Created by Alex Larin on 02.10.2020.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userRepository = UserRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldState()
        addObservers()
        
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let userFromRealm = try? userRepository.searchUser(login: login)
        if
            ((userFromRealm?.isEmpty) == true && login != ""){
            let user = UserModel(login: login , password: password)
            userRepository.saveUserData(user: user)
            performSegue(withIdentifier: "toMain", sender: sender)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Выберите другой логин", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { _ in
                self.passwordTextField.text = ""
                self.loginTextField.text = ""
            }
            
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    func textFieldState() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        loginTextField.autocorrectionType = .no
    }
    // Подписка на уведомления (приложение не активно - активно)
    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideTextFields), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showTextFields), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    // сбросить логин и пароль
    @objc func hideTextFields() {
        self.passwordTextField.text = "Error"
        self.loginTextField.text = "Error"
        self.passwordTextField.isSecureTextEntry = false
        
    }
    // повтор регистрации
    @objc func showTextFields() {
        let alert = UIAlertController(title: "Error", message: "Повторите регистрацию", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.passwordTextField.text = ""
            self.loginTextField.text = ""
            self.passwordTextField.isSecureTextEntry = true
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
}
