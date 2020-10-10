//
//  PathRepository.swift
//  NextSwift
//
//  Created by Alex Larin on 29.09.2020.
//

import Foundation
import RealmSwift

class PathRepository{
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: false)
    
    // метод сохранения координат точки в Realm:
    static func savePathData<T: Object>(items: [T],
    configuration: Realm.Configuration = deleteIfMigration,
    update: Realm.UpdatePolicy = .modified) throws {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        try realm.write {
            realm.add(items, update: update)
        }
    }
    
    // метод получения пути пользователя из Realm:
    static func getPathData<T: Object>(_ type: T.Type,
                               configuration: Realm.Configuration = deleteIfMigration) throws -> Results<T> {
        print(configuration.fileURL ?? "")
        let realm = try Realm(configuration: configuration)
        return realm.objects(type)
    }
    // метод очистки БД
    static func clearDB(configuration: Realm.Configuration = deleteIfMigration) throws {
        let realm = try Realm(configuration: configuration)
        try realm.write {
            realm.deleteAll()
        }
    }
}
