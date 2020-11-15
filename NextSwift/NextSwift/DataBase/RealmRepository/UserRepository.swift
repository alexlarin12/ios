//
//  UserRepository.swift
//  NextSwift
//
//  Created by Alex Larin on 02.10.2020.
//

import Foundation
import RealmSwift

class UserRepository {
    var realmUsers = [RealmUser]()
    var realmUser = RealmUser()
    // метод сохранения пользователя в Realm:
    func saveUserData(user: UserModel){
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded:false)
            let realm = try Realm(configuration: config)
            var userToAdd = [RealmUser]()
            realm.beginWrite()
            realm.deleteAll()
            let realmUser = RealmUser()
                realmUser.login = user.login
                realmUser.password = user.password
                userToAdd.append(realmUser)
            realm.add(userToAdd, update: .modified)
            try realm.commitWrite()
            print(try! Realm().configuration.fileURL!)
        } catch {
            print(error)
        }
    }
    
    // метод получения пользователя из Realm:
    func getUserData() -> Array<RealmUser>{
        do {
            let realm = try Realm()
            let userFromRealm = realm.objects(RealmUser.self)
            self.realmUsers = Array(userFromRealm)
        } catch {
            print(error)
        }
        return realmUsers
    }
    
    func searchUser(login: String) throws -> Array<RealmUser> {
          do {
              let realm = try Realm()
              let userRealm = realm.objects(RealmUser.self).filter("login CONTAINS[c] %@", login)
            self.realmUsers = Array(userRealm)
          } catch {
              throw error
          }
        return realmUsers
    }
    func compareUserData(login: String, password: String) throws -> Array<RealmUser> {
          do {
              let realm = try Realm()
              let userRealm = realm.objects(RealmUser.self).filter("login = '\(login)' AND password = '\(password)'")
            self.realmUsers = Array(userRealm)
          } catch {
              throw error
          }
        return realmUsers
    }
    
}
