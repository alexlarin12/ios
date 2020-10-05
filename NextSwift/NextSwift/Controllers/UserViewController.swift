//
//  UserViewController.swift
//  NextSwift
//
//  Created by Alex Larin on 02.10.2020.
//

import UIKit

class UserViewController: UIViewController {
    let userRepository = UserRepository()
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func enterAction(_ sender: UIButton) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let userFromRealm = try? userRepository.compareUserData(login: login, password: password)
        if ((userFromRealm?.isEmpty) == false ){
            // Сохраним флаг, показывающий, что мы авторизованы.
            UserDefaults.standard.set(true, forKey: "isLogin")
            performSegue(withIdentifier: "toMain", sender: sender)
        }else{
            let alert = UIAlertController(title: "Error", message: "Ошибка авторизации", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { _ in
                self.passwordTextField.text = ""
                self.loginTextField.text = ""
            }
            alert.addAction(action)
            present(alert, animated: true)
            
        }
    }
    @IBAction func registrationAction(_ sender: UIButton) {
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    @IBAction func recoveryAction(_ sender: UIButton) {
        performSegue(withIdentifier: "onRecovery", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Показав контроллер авторизации, проверяем: если мы авторизованы, сразу переходим к основному сценарию.
        if UserDefaults.standard.bool(forKey: "isLogin") {
            performSegue(withIdentifier: "toMain", sender: self)
        }
    }
    
    @IBAction func unwindSegue(unwindSegue: UIStoryboardSegue){
        UserDefaults.standard.set(false, forKey: "isLogin")
    }

}
