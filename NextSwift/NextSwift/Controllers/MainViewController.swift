//
//  MainViewController.swift
//  NextSwift
//
//  Created by Alex Larin on 04.10.2020.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func showMap(_ sender: UIButton) {
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        performSegue(withIdentifier: "toLaunch", sender: nil)
    }
    @IBAction func unwindSegue(unwindSegue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
}
