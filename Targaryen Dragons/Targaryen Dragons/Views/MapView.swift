//
 //  MapViewRepresentable.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import SwiftUI
 import MapKit

 enum MapViewState {
     case noInput
     case searchingForLocation
     case locationSelected
     case polylineAdded
     case mapSettingShown
     case startNavigating
 }

 struct MapView: UIViewRepresentable {

     let mapView = MKMapView()
     @Binding var mapState: MapViewState
     @EnvironmentObject var locationViewModel: LocationSearchViewModel
     @StateObject var mapConfigurationManager = MapConfiguartionManager.shared
     @StateObject private var locationManager: LocationManager = LocationManager.shared
     
     //Mumbai Wadala West Coordinate
     let startLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.020037299999988,
                                                                     longitude: 72.85359069999998)
     
     func makeUIView(context: Context) -> some MKMapView {
         mapView.showsUserLocation = true
         mapView.userTrackingMode = .follow
         mapView.isScrollEnabled = true
         mapView.delegate = context.coordinator
         let region = MKCoordinateRegion(
            center: startLocationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
         )
         mapView.setRegion(region, animated: true)
         return mapView
     }

     func updateUIView(_ uiView: UIViewType, context: Context) {
         switch mapState {
         case .noInput:
             mapView.showsUserLocation = true
             context.coordinator.clearMapViewAndRecenterOnUserLocation()
             context.coordinator.addAndSelectAnnotation(withCoordinate: startLocationCoordinate)
             updateMapType(mapView)
             break
         case .searchingForLocation:
             mapView.showsUserLocation = false
             break
         case .locationSelected:
             mapView.showsUserLocation = false
             if let coordinate = locationViewModel.selectedLocation?.coordinate {
                 print("DEBUG: Adding stuff to map..")
                 context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                 context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
             }
             break
         case .polylineAdded:
             mapView.showsUserLocation = true
             //Action: Route Tracing By Iterating over array of coordinates.
             break
         case .mapSettingShown:
             mapView.showsUserLocation = false
             updateMapType(uiView)
             break
         case .startNavigating:
             traceRoute(context)
             break
         }
     }
     
     func traceRoute(_ context: Context) {
         locationViewModel.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
             let coordinate = self.locationViewModel.routeCoordinates[locationViewModel.currentLocationIndex]
             context.coordinator.setRegion(coordinate)
             context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
             locationViewModel.updatePropertiesOnTimer()
             if(locationViewModel.currentLocationIndex == 0) {
                 locationViewModel.startLiveActivity()
             } else {
                 locationViewModel.updateLiveActivity()
             }
             locationViewModel.incrementCurrentLocationIndex()
             if locationViewModel.currentLocationIndex == locationViewModel.routeCoordinates.count - 1 {
                 locationViewModel.startLiveActivity()
                 timer.invalidate()
                 locationViewModel.timer = nil
                 locationViewModel.resetCurrentLocationIndex()
             }
         }
     }
     
     func makeCoordinator() -> MapCoordinator {
         return MapCoordinator(parent: self)
     }
 }

 extension MapView {

     class MapCoordinator: NSObject, MKMapViewDelegate {

         let parent: MapView
         var userLocationCoordinate: CLLocationCoordinate2D?
         var currentRegion: MKCoordinateRegion?

         init(parent: MapView) {
             self.parent = parent
             super.init()
             self.userLocationCoordinate = parent.startLocationCoordinate
         }

         func resetToCurrentLocation() {
             guard let region = currentRegion else { return }
             parent.mapView.setRegion(region, animated: true)
         }
         
         func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
             self.userLocationCoordinate = userLocation.coordinate
             let region = MKCoordinateRegion(
                 center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                 span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
             )
             
             self.currentRegion = region
             parent.mapView.setRegion(region, animated: true)
         }

         func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
             let polyline = MKPolylineRenderer(overlay: overlay)
             polyline.strokeColor = .systemBlue
             polyline.lineWidth = 6
             return polyline
         }

         func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
             parent.mapView.removeAnnotations(parent.mapView.annotations)

             let anno = MKPointAnnotation()
             anno.coordinate = coordinate
             parent.mapView.addAnnotation(anno)
             parent.mapView.selectAnnotation(anno, animated: true)
         }
         
         func setRegion(_ coordinate: CLLocationCoordinate2D) {
             let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
             )
             print("updating Region")
             parent.mapView.setRegion(region, animated: true)
         }

         func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
             guard let userLocationCoordinate = self.userLocationCoordinate else { return }

             parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                          to: coordinate) { [self] route in
                 self.parent.animateTravel(parent.mapView, startCoordinate: userLocationCoordinate)
             }
         }

         func clearMapViewAndRecenterOnUserLocation() {
             parent.mapView.removeAnnotations(parent.mapView.annotations)
             parent.mapView.removeOverlays(parent.mapView.overlays)

             if let currentRegion = currentRegion {
                 parent.mapView.setRegion(currentRegion, animated: true)
             }
         }
     }
 }
