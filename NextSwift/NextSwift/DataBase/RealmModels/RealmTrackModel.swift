//
//  TrackRealmModel.swift
//  NextSwift
//
//  Created by Alex Larin on 29.09.2020.
//

import Foundation
import RealmSwift

final class RealmTrackModel: Object {
    @objc dynamic var id: Int = 0
    let locationPoints = List<RealmCoordinatesModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
