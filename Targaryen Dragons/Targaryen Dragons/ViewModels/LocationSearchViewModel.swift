//
 //  LocationSearchViewModel.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import Foundation
 import MapKit

//TODO: Remember Simulated Location is set from Wadala west to Gateway of India

 class LocationSearchViewModel: NSObject, ObservableObject {

     @Published var results = [MKLocalSearchCompletion]()
     @Published var routeSteps: [RouteStep] =  []
     @Published var selectedLocation: DragonLocation?
     @Published var expectedArrivalTime: String?

     private let searchCompleter = MKLocalSearchCompleter()
     var queryFragment: String = "" {
         didSet {
             searchCompleter.queryFragment = queryFragment
         }
     }

     var userLocation: CLLocationCoordinate2D?

     override init() {
         super.init()
         searchCompleter.delegate = self
         searchCompleter.queryFragment = queryFragment
     }

     func selectLocation(_ localSearch: MKLocalSearchCompletion) {
         locationSearch(forLocalSearchCompletion: localSearch) { response, error in
             if let error = error {
                 print("DEBUG: Location search failed with error \(error.localizedDescription)")
                 return
             }

             guard let item = response?.mapItems.first else { return }
             let coordinate = item.placemark.coordinate
             self.selectedLocation = DragonLocation(title: localSearch.title,
                                                      coordinate: coordinate)
             print("DEBUG: Location coordinates \(coordinate)")
         }
     }

     func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                         completion: @escaping MKLocalSearch.CompletionHandler) {
         let searchRequest = MKLocalSearch.Request()
         searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
         let search = MKLocalSearch(request: searchRequest)

         search.start(completionHandler: completion)
     }

     func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                              to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
         let userPlacemark = MKPlacemark(coordinate: userLocation)
         let destPlacemark = MKPlacemark(coordinate: destination)
         let request = MKDirections.Request()
         request.source = MKMapItem(placemark: userPlacemark)
         request.destination = MKMapItem(placemark: destPlacemark)
         let directions = MKDirections(request: request)
         directions.calculate { response, error in
             if let error = error {
                 print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                 return
             }

             guard let route = response?.routes.first else { return }
             self.routeSteps = route.steps.map { RouteStep(step: $0) }

             // ----------- Code required to generate coordinates ---------
             var coordinates = [String]()
             for (index, item) in route.steps.enumerated() {
                 
                 let str = "<wpt lat="
                     .appending("\(item.polyline.coordinate.latitude)")
                     .appending(" lon=")
                     .appending("\(item.polyline.coordinate.longitude)")
                     .appending("> <name> Point \(index) </name> </wpt>")
                 
                 coordinates.append(str)
             }
             print("coordinates wpt \(coordinates)")
             // ----------- Code required to generate coordinates ---------
             
             self.getExpectedTravelTime(with: route.expectedTravelTime)
             completion(route)
         }
     }

     func getExpectedTravelTime(with expectedTravelTime: Double) {
         let formatter = DateFormatter()
         formatter.dateFormat = "hh:mm a"
         expectedArrivalTime = formatter.string(from: Date() + expectedTravelTime)
     }
 }

 // MARK: - MKLocalSearchCompleterDelegate

 extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
     func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
         self.results = completer.results
     }
 }
