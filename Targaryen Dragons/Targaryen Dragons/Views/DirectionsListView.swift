//
 //  DirectionsListView.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 27/10/22.
 //

 import SwiftUI
 import MapKit

 struct DirectionsListView: View {

     let routeSteps: [RouteStep]

     //@StateObject private var locationManager: LocationManager = LocationManager.shared

     var body: some View {
         List(routeSteps) { routeStep in
             Text(routeStep.step.instructions)
                 .onTapGesture {
                     //TODO: Select Tapped Region on Map
                     //locationManager.selectRegionOnMap(selectedRegion: MKCoordinateRegion(routeStep.step.polyline.boundingMapRect))
                 }
         }
     }
 }
