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
    
    var marker: GMSMarker?
   
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
        // запрос доступа к геопозиции только в момент использования приложения
        locationManager?.requestWhenInUseAuthorization()
  }
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.title = "Привет"
        marker.snippet = "Я здесь"
        marker.map = mapView
        self.marker = marker
        
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    @IBAction func trackAction(_ sender: UIBarButtonItem) {
            // отслеживание изменения местоположения устройства
            locationManager?.startUpdatingLocation()
    }
    
    @IBAction func currentAction(_ sender: UIBarButtonItem) {
        if marker == nil {
            // запрос текущей геопозиции
            locationManager?.requestLocation()
        } else {
            removeMarker()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationFirst = locations.first{
        configureMap(coordinate: locationFirst.coordinate)
        addMarker(coordinate: locationFirst.coordinate)
       
        }else{
           print("no coordinate")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
