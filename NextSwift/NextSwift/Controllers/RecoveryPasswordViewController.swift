//
//  RecoveryPasswordViewController.swift
//  NextSwift
//
//  Created by Alex Larin on 04.10.2020.
//

import UIKit

class RecoveryPasswordViewController: UIViewController {
    let userRepository = UserRepository()
    var userResult = UserModel(login: "", password: "")
    @IBOutlet weak var loginView: UITextField!
    
    @IBAction func recovery(_ sender: Any) {
        guard let login = loginView.text else {return}
        let userFromRealm = try? userRepository.searchUser(login: login)
        userFromRealm?.forEach{ user in
            userResult.login = user.login
            userResult.password = user.password
            let alert = UIAlertController(title: "Пароль", message: user.password, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
