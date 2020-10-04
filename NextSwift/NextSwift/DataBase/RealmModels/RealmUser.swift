//
//  RealmUser.swift
//  NextSwift
//
//  Created by Alex Larin on 02.10.2020.
//

import Foundation
import RealmSwift
class RealmUser: Object {
    @objc dynamic var login:String = ""
    @objc dynamic var password:String = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
    
}
