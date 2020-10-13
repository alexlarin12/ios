//
//  MapViewController.swift
//  NextSwift
//
//  Created by Alex Larin on 26.09.2020.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift
import RxSwift


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // свойство для хранения CoreLocation менеджера
    //  var locationManager: CLLocationManager?
    let locationManager = LocationManager.instance
    // свойство для хранения объекта пути:
    var route: GMSPolyline?
    // свойство для хранения пути:
    var routePath: GMSMutablePath?
    private var routeRealm: RealmTrackModel?
    private var routePathRealm: RealmCoordinatesModel?
    var newPath = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        
        
    }
    func configureMap(coordinate: CLLocationCoordinate2D){
        let camera = GMSCameraPosition(target: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.animate(toLocation: coordinate)
    }
    
    // создание CoreLocation менеджера и запрос к доступу к геопозиции
    /*
     func configureLocationManager(){
     locationManager = CLLocationManager()
     // делегат для менеджера
     locationManager?.delegate = self
     // запрос разрешения на работу геолокации в фоне у пользователя
     locationManager?.allowsBackgroundLocationUpdates = true
     // чтобы слежение не останавливалось при остановке объекта:
     locationManager?.pausesLocationUpdatesAutomatically = false
     // запускать приложение при определённых изменениях местоположения:
     locationManager?.startMonitoringSignificantLocationChanges()
     // точность определения местоположения (лучшая):
     locationManager?.desiredAccuracy = kCLLocationAccuracyBest
     // запрос доступа к геопозиции только в момент использования приложения
     //locationManager?.requestWhenInUseAuthorization()
     // запрос доступа к геопозиции всегда
     locationManager?.requestAlwaysAuthorization()
     }*/
    
    func configureLocationManager() {
        _ = locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                // Обновляем путь у линии маршрута путём повторного присвоения
                self?.route?.path = self?.routePath
                
                // Чтобы наблюдать за движением, установим камеру на только что добавленную точку
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
            }
    }
    
    func addLine(){
        // Отвязываем от карты старую линию
        route?.map = nil
        // Заменяем старую линию новой
        route = GMSPolyline()
        // Заменяем старый путь новым, пока пустым (без точек)
        routePath = GMSMutablePath()
        // цвет объекта пути:
        route?.strokeColor = .green
        // ширина объекта пути:
        route?.strokeWidth = 7
        // Добавляем новую линию на карту
        route?.map = mapView
    }
    private func loadRealmModel() {
        guard let routeRealm = try? PathRepository.getPathData(RealmTrackModel.self).last else {
            self.routeRealm = RealmTrackModel()
            self.routeRealm?.id = 1
            try? PathRepository.savePathData(items: [self.routeRealm!])
            return
        }
        self.routeRealm = routeRealm
    }
    private func addRealmPoint(location: CLLocationCoordinate2D) {
        let realmCoordinates = RealmCoordinatesModel()
        realmCoordinates.latitude = location.latitude
        realmCoordinates.longitude = location.longitude
        guard let realm = try? Realm(configuration: .defaultConfiguration) else { return }
        try! realm.write {
            routeRealm?.locationPoints.append(realmCoordinates)
        }
    }
    private func getRealmPath(completion: ([CLLocationCoordinate2D]?) -> Void){
        guard let previosRoute = try? PathRepository.getPathData(RealmTrackModel.self).first else {
            completion(nil)
            return
        }
        var route: [CLLocationCoordinate2D] = []
        previosRoute.locationPoints.forEach { point in
            route.append(point.coordinate)
        }
        completion(route)
        
    }
    
    
    
    @IBAction func newTrackAction(_ sender: UIBarButtonItem) {
        addLine()
        // отслеживание изменения местоположения устройства
        locationManager.startUpdatingLocation()
        
        
    }
    
    @IBAction func stopTrackAction(_ sender: UIBarButtonItem) {
        locationManager.stopUpdatingLocation()
        try? PathRepository.clearDB()
        loadRealmModel()
        guard let routePath = routePath else { return }
        // Цикл по всем точкам (координатам) маршрута.
        for i in 0..<routePath.count(){
            let coordinate = routePath.coordinate(at: i)
            addRealmPoint(location: coordinate)
        }
        /*
         for element in newPath{
         addRealmPoint(location: element)
         }*/
    }
    
    @IBAction func lastTrackAction(_ sender: UIBarButtonItem) {
        locationManager.stopUpdatingLocation()
        
        getRealmPath(){routeRealm in
            var lastPath:[CLLocationCoordinate2D] = []
            lastPath = routeRealm ?? []
            addLine()
            for coordinatePoint in lastPath{
                routePath?.add(coordinatePoint)
                newPath.append(coordinatePoint)
                route?.path = routePath
                // Чтобы наблюдать за движением, установим камеру на только что добавленную точку
                configureMap(coordinate: coordinatePoint)
                
            }
        }
        
    }
    
    
    
}
/*
 extension MapViewController: CLLocationManagerDelegate {
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 // Берём последнюю точку из полученного набора
 guard let location = locations.last else { return }
 // Добавляем её в путь маршрута
 routePath?.add(location.coordinate)
 newPath.append(location.coordinate)
 // Обновляем путь у линии маршрута путём повторного присвоения
 route?.path = routePath
 // Чтобы наблюдать за движением, установим камеру на только что добавленную точку
 configureMap(coordinate: location.coordinate)
 }
 
 func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
 print(error)
 }
 }
 */
