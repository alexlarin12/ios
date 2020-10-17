//
//  PathRepository.swift
//  NextSwift
//
//  Created by Alex Larin on 29.09.2020.
//

import Foundation
import RealmSwift
import CoreLocation
import GoogleMaps

class PathRepository{
    // Сохранение маршрута в Realm.
    func addLastRoute(routePath: [PathModel]) {
        // Обработка исключений при работе с хранилищем.
        do {
            // Получаем доступ к хранилищу.
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded:false)
            let realm = try Realm(configuration: config)
            // Путь к хранилищу.
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            
            // Начинаем изменять хранилище.
            realm.beginWrite()
           // realm.deleteAll()
            
            var routePathToAdd = [RealmCoordinatesModel]()
            // Цикл по всем точкам (координатам) маршрута.
            routePath.forEach { routh in
                let routhPathRealm = RealmCoordinatesModel()
                routhPathRealm.latitude = routh.latitude
                routhPathRealm.longitude = routh.longitude
                routePathToAdd.append(routhPathRealm)
              
            }
                // Кладем все объекты класса CLLocation в хранилище.
            realm.add(routePathToAdd)
            // Завершаем изменения хранилища.
            try realm.commitWrite()
        } catch {
            // Если произошла ошибка, выводим ее в консоль.
            print(error)
        }
    }
    
    // метод получения пути пользователя из Realm:
    func getPathData() throws -> Results<RealmCoordinatesModel> {
        do{
        let realm = try Realm()
            return realm.objects(RealmCoordinatesModel.self)
        }catch{
            throw error
        }
    }
    // метод очистки БД
    func clearDB(){
        do{
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
            
        }catch{
            print(error)
        }
    }
}
