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
  //  private var routeRealm: RealmTrackModel?
    private var routePathRealm: RealmCoordinatesModel?
    let dataBase = PathRepository()
  //  var newPath = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        
        
    }
    func configureMap(coordinate: CLLocationCoordinate2D){
        let camera = GMSCameraPosition(target: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.animate(toLocation: coordinate)
    }
    
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
   
    private func getRealmPath(completion: ([CLLocationCoordinate2D]?) -> Void){
        guard let previosRoute = try? dataBase.getPathData() else {
            completion(nil)
            return
        }
        var route: [CLLocationCoordinate2D] = []
        var coordinate: CLLocationCoordinate2D = (.init(latitude: 0.0, longitude: 0.0))
        
        previosRoute.forEach { point in
            coordinate.latitude = point.latitude
            coordinate.longitude = point.longitude
            route.append(coordinate)
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
        dataBase.clearDB()
   
        guard let routePath = routePath else { return }
        // Цикл по всем точкам (координатам) маршрута.
        var pathArray = [PathModel]()
        for i in 0..<routePath.count(){
            let coordinate = routePath.coordinate(at: i)
            let pathModel = PathModel(latitude: coordinate.latitude, longitude: coordinate.longitude)
            pathArray.append(pathModel)
        }
        dataBase.addLastRoute(routePath: pathArray)
       pathArray = []
    }
    
    @IBAction func lastTrackAction(_ sender: UIBarButtonItem) {
        locationManager.stopUpdatingLocation()
        
        getRealmPath(){routeFromRealm in
            var lastPath:[CLLocationCoordinate2D] = []
            lastPath = routeFromRealm ?? []
            addLine()
            for coordinatePoint in lastPath{
                routePath?.add(coordinatePoint)
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
