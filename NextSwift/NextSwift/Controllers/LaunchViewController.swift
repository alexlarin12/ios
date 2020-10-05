//
//  LaunchViewController.swift
//  NextSwift
//
//  Created by Alex Larin on 04.10.2020.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool ) {
        super.viewDidAppear(true)
        if UserDefaults.standard.bool(forKey: "isLogin") {
            performSegue(withIdentifier: "toMain", sender: self)
        } else {
            performSegue(withIdentifier: "toAuth", sender: self)
        }
    }
}
