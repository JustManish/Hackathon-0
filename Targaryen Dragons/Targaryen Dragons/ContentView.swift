//
//  ContentView.swift
//  Targaryen Dragons
//
//  Created by Nasir Ahmed Momin on 27/10/22.
//

import SwiftUI

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct RouteSteps: Identifiable {
    let id = UUID()
    let step: MKRoute.Step
}

let locations = [
    Location(name: "Rashtrapati Bhawan", coordinate: CLLocationCoordinate2D(latitude: 28.6143, longitude: 77.1994)),
    Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 28.6562, longitude: 77.2410))
]
struct ContentView: View {
    @State
    var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.6129, longitude: 77.2295), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var searchBar: String = ""
    @State private var home = CLLocationCoordinate2D(latitude: 28.6142, longitude: 77.1994)
    @State var routeSteps: [RouteSteps] = []
    @State var annotations = locations
    
    
    
    var body: some View {
        
        VStack{
            HStack {
                TextField("", text: $searchBar)
                Button("Go") {
                    findNewLocation()
                }
                .frame(width: 35, height: 35)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(5)
            }.textFieldStyle(.roundedBorder).colorInvert()
            Map(coordinateRegion: $region, annotationItems: annotations){ item in
                MapMarker(coordinate: item.coordinate)
            }.frame(minHeight: 400)
            List(routeSteps) { routeStep in
                // Pull your instructions out here
                Text(routeStep.step.instructions)
                    .onTapGesture {
                        region = MKCoordinateRegion(routeStep.step.polyline.boundingMapRect)
                    }
            }
        }
    }
    
    func findNewLocation(){
        let searchResult = searchBar
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchResult, completionHandler:
                                        {(placemarks, error) -> Void in
            if((error) != nil){
                print("error at geocode")
            }
            if let placemark = placemarks?.first {
                let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                annotations.append(Location(name: placemark.name!, coordinate: coordinates))
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: home, addressDictionary: nil))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                request.requestsAlternateRoutes = false
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                directions.calculate(completionHandler: { response, error in
                    guard let response = response else { return }
                    for route in response.routes {
                        self.routeSteps = route.steps.map( { RouteSteps(step: $0) } )
                    }
                })
            }
        })
    }
}
struct ContentView_Previews: PreviewProvider {
    static
    var previews: some View {
        ContentView()
    }
}
