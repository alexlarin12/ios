//
//  MapViewController.swift
//  NextSwift
//
//  Created by Alex Larin on 26.09.2020.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // свойство для хранения CoreLocation менеджера
    var locationManager: CLLocationManager?
    // свойство для хранения объекта пути:
    var route: GMSPolyline?
    // свойство для хранения пути:
    var routePath: GMSMutablePath?
   
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
    @IBAction func newTrackAction(_ sender: UIBarButtonItem) {
        addLine()
        // отслеживание изменения местоположения устройства
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction func stopTrackAction(_ sender: UIBarButtonItem) {
        locationManager?.stopUpdatingLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Берём последнюю точку из полученного набора
        guard let location = locations.last else { return }
        // Добавляем её в путь маршрута
        routePath?.add(location.coordinate)
        // Обновляем путь у линии маршрута путём повторного присвоения
        route?.path = routePath
        // Чтобы наблюдать за движением, установим камеру на только что добавленную точку
        configureMap(coordinate: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
