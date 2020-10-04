//
//  RootSegue.swift
//  NextSwift
//
//  Created by Alex Larin on 04.10.2020.
//

import UIKit

class RootSegue: UIStoryboardSegue {
    override func perform() {
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = destination
    }
}
