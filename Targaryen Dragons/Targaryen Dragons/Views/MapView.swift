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
         mapView.isRotateEnabled = false
         mapView.showsUserLocation = true
         mapView.userTrackingMode = .follow
         mapView.isScrollEnabled = true
         mapView.delegate = context.coordinator
         let region = MKCoordinateRegion(
            center: startLocationCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
         )
         //mapView.region = region
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
             //Trace the route here...
             traceRoute(context: context)
             print("coordinates count: \(self.locationViewModel.routeCoordinates.count)")
             break
         case .mapSettingShown:
             mapView.showsUserLocation = false
             updateMapType(uiView)
             break
         }
     }
     
     func traceRoute(context: Context) {
         let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
             let coordinate = self.locationViewModel.routeCoordinates[locationViewModel.currentLocationIndex]
             let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
             )
             print("updating Region")
             context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
             self.mapView.setRegion(region, animated: true)
             locationViewModel.incrementCurrentLocationIndex()
             if locationViewModel.currentLocationIndex == locationViewModel.routeCoordinates.count - 1 {
                 timer.invalidate()
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

         func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
             guard let userLocationCoordinate = self.userLocationCoordinate else { return }

             parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate,
                                                          to: coordinate) { route in
                 self.parent.mapView.addOverlay(route.polyline)
                 self.parent.mapState = .polylineAdded
                 let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                                edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                 self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
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

extension MapView {
    
    private func updateMapType(_ mapView: MKMapView) {
        switch mapConfigurationManager.mapType {
        case .standard(let elevation, let style):
            let configuration = MKStandardMapConfiguration(elevationStyle: elevation.value,
                                                           emphasisStyle: style.value)
            configuration.pointOfInterestFilter = MKPointOfInterestFilter(including: [.atm,.airport,.beach,.nationalPark])
            configuration.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.bakery])
            configuration.showsTraffic = false
            mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle:elevation.value, emphasisStyle: style.value)
            
        case .hybrid(let elevation, _):
            mapView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: elevation.value)// this uses satelite images and road names, can se the globe in realistic
            
        case .image(let elevation, _):
            
            mapView.preferredConfiguration = MKImageryMapConfiguration(elevationStyle: elevation.value) //flat - just images dont see the globe, realistic 3D realistic building can see the globe
        }
    }
}
