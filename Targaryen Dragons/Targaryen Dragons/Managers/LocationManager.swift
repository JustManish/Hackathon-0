//
 //  LocationManager.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import CoreLocation

 class LocationManager: NSObject, ObservableObject {
     private let locationManager = CLLocationManager()
     static let shared = LocationManager()
     @Published var userLocation: CLLocationCoordinate2D?

     override init() {
         super.init()
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
         locationManager.startUpdatingLocation()
     }
 }

 extension LocationManager: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.first else { return }
//         CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//             self.userLocation = placemarks?.first
//         }
         self.userLocation = location.coordinate
         locationManager.stopUpdatingLocation()
     }
 }
