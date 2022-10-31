//
//  MapView+Extension.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 31/10/22.
//

import Foundation
import MapKit

//MapConfiguration
extension MapView {
    
     func updateMapType(_ mapView: MKMapView) {
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

    func animateArrival(_ mapView:MKMapView,
                                onCurrentLocation: Bool,
                                afterDelay delay: Double = 0) {
        guard let stop = locationViewModel.selectedLocation else { return }
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
                mapView.camera = MKMapCamera(lookingAt: stop.mapItem, forViewSize: mapView.bounds.size, allowPitch: true)
            } completion: { [self] _ in
                configureArrival(mapView)
            }
        }
    }
    
    func configureArrival(_ mapView:MKMapView) {
        guard let stop = locationViewModel.selectedLocation else { return }
        locationViewModel.lookAroundScene(for: stop.mapItem)
    }
    
    func animateTravel(_ mapView:MKMapView,
                               startCoordinate: CLLocationCoordinate2D?) {
        mapView.removeOverlays(mapView.overlays)
        
        Task {
            if let mapRoute = locationViewModel.route, let startCoordinate {
                
                mapView.addOverlay(mapRoute.polyline)
                self.mapState = .polylineAdded
                
                UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
                    
                    let insets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
                    let startDestination = MKMapRect(origin: MKMapPoint(startCoordinate),
                                                     size: MKMapSize(width: 1, height: 1))
                    let navigationVisibleRect = mapRoute.polyline.boundingMapRect.union(startDestination)
                    mapView.setVisibleMapRect(navigationVisibleRect, edgePadding: insets, animated: true)
                } completion: { _ in
                    
                    UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut) {
                        let pointCount = mapRoute.polyline.pointCount
                        let lastPoint = mapRoute.polyline.points()[pointCount - 1]
                        mapView.camera = MKMapCamera(lookingAtCenter: lastPoint.coordinate, fromDistance: 1500, pitch: 60, heading: 0)
                    } completion: { _ in
                        self.animateArrival(mapView, onCurrentLocation: false)
                    }
                }
            }
            else {
                animateArrival(mapView, onCurrentLocation: false)
            }
        }
    }
}
