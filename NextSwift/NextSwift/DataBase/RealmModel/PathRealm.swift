//
//  PathRealm.swift
//  NextSwift
//
//  Created by Alex Larin on 29.09.2020.
//

import Foundation
import RealmSwift

class PathRealm:Object{
    
    @objc dynamic var id:Int = 0
    @objc dynamic var lat:Double = 0
    @objc dynamic var long:Double = 0
    
    override class func primaryKey() -> String? {
           return "id"
    }
    
}
