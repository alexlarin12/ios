//
//  PathRealm.swift
//  NextSwift
//
//  Created by Alex Larin on 29.09.2020.
//

import Foundation
import RealmSwift
import CoreLocation


class RealmCoordinatesModel:Object{
    
    @objc dynamic var latitude:Double = 0
    @objc dynamic var longitude:Double = 0
 
}


