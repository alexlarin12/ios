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
}
