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

     func makeUIView(context: Context) -> some MKMapView {
         mapView.isRotateEnabled = false
         mapView.showsUserLocation = true
         mapView.userTrackingMode = .follow
         mapView.isScrollEnabled = true
         mapView.delegate = context.coordinator
         return mapView
     }

     func updateUIView(_ uiView: UIViewType, context: Context) {
         switch mapState {
         case .noInput:
             mapView.showsUserLocation = true
             context.coordinator.clearMapViewAndRecenterOnUserLocation()
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
             mapView.showsUserLocation = false
             break
         case .mapSettingShown:
             mapView.showsUserLocation = false
             updateMapType(uiView)
             break
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
                                                          to: coordinate) { [self] route in
                 //self.parent.mapView.addOverlay(route.polyline)
                 self.parent.animateTravel(parent.mapView, startCoordinate: userLocationCoordinate)
//                 self.parent.mapState = .polylineAdded
//                 let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
//                                                                edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
//                 self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
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

extension MapView {
    
    /// After a configurable delay, animates the camera to the preferred vantage point for the map item you're arriving at, before setting up the
    /// user interface for Look Around at this location and preparing for the next stop.
    private func animateArrival(_ mapView:MKMapView,onCurrentLocation: Bool, afterDelay delay: Double = 0) {
        guard let stop = locationViewModel.selectedLocation else { return }
        
        // Asynchronously wait for the duration of the delay, and then start the animation.
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
                // When a `MKMapItem` represents a landmark, `MKMapCamera` uses a curated camera framing
                // that is best for the specific landmark when created through `MKMapCamera(lookingAt:forViewSize:allowPitch:)`.
                mapView.camera = MKMapCamera(lookingAt: stop.mapItem, forViewSize: mapView.bounds.size, allowPitch: true)
            } completion: { [self] _ in
                configureArrival(mapView)
            }
        }
    }
    
    /// Sets up the user interface for Look Around at this stop .
    private func configureArrival(_ mapView:MKMapView) {
        guard let stop = locationViewModel.selectedLocation else {
            return
        }
        locationViewModel.lookAroundScene(for: stop.mapItem)
    }
    
    /// Animates the camera along the route to the next stop.
    private func animateTravel(_ mapView:MKMapView,startCoordinate: CLLocationCoordinate2D?) {
//        let currentStop = locationManager.annotatedLocations[stopIndex]
//        let nextStop = locationManager.annotatedLocations[stopIndex + 1]
        // Remove the previous route overlay.
        mapView.removeOverlays(mapView.overlays)
        
        // Asynchronously finish loading the route, if necessary, and start the travel animation when loading is done.
        Task {
            
            /*
             Display the driving directions, and animate the map so the starting point, ending point,
             and the overall route are visible.
             
             When the map is pitched, route polylines created through `MKDirections.Request` follow the elevation of the
             terrain, such as hills, overpasses, and bridges. Further, these polylines blend with the surrounding landscape,
             so they are visible through buildings, trees, and in tunnels. Take note of these examples:
             
             1. When navigating from the Golden Gate Bridge to the Palace of Fine Arts, the route goes through multiple
             tunnels. If you zoom in on these sections of the route, the section of the polyline in the tunnels is blended with
             the surrounding terrain.
             
             2. When zooming in to Coit Tower, the elevation of Telegraph Hill becomes visible, and the route polyline follows
             the road elevation as it ascends Telegraph Hill to Coit Tower. The route polyline to Sutro Tower also demonstrates this.
             */
            if let mapRoute = locationViewModel.route, let startCoordinate {
                
                mapView.addOverlay(mapRoute.polyline)
                self.mapState = .polylineAdded

                /*
                 Animate the starting point for navigation into view. The origin might be out of view if the user
                 moved the map away from the landmark, or if the starting point is significantly separated from the
                 landmark. For example, navigating away from Alcatraz Island starts at the boat dock in San Francisco,
                 so adjust the visible map rectangle to include the navigation starting point as well as the landmark.
                 */
                UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {

                    // Bring the start and end points away from the edge of the map.
                    let insets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
                    let startDestination = MKMapRect(origin: MKMapPoint(startCoordinate), size: MKMapSize(width: 1, height: 1))
                    let navigationVisibleRect = mapRoute.polyline.boundingMapRect.union(startDestination)
                    mapView.setVisibleMapRect(navigationVisibleRect, edgePadding: insets, animated: true)
                } completion: { _ in

                    UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
                        /*
                         This animation zooms in to the last point on the navigation route. For most cases, this is the
                         same location as the destination landmark on the tour. For Alcatraz Island, the last navigation
                         point is the ferry departure point. Subsequent animations animate to Alcatraz Island itself.
                         */
                        let pointCount = mapRoute.polyline.pointCount
                        let lastPoint = mapRoute.polyline.points()[pointCount - 1]
                        
                        // Because this animation comes after the map animates out to be unpitched, a heading of 0 results in a smooth
                        // transition (without undue rotation) as the map zooms in on the destination while regaining a pitch.
                        mapView.camera = MKMapCamera(lookingAtCenter: lastPoint.coordinate, fromDistance: 1500, pitch: 60, heading: 0)
                    } completion: { _ in
                        self.animateArrival(mapView, onCurrentLocation: false)
                    }
                }
            }
            
            // Otherwise, animate directly to the next stop location.
            else {
                animateArrival(mapView, onCurrentLocation: false)
            }
        }
    }
}
