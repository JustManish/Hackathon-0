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
     @Published var route: MKRoute?
     @Published var selectedLocation: DragonLocation?
     @Published var expectedArrivalTime: String?
     @Published var lookAroundScene : MKLookAroundScene?
     @Published var routeCoordinates: [CLLocationCoordinate2D] = []
     
     var expectedTravelTimePerCoordinates: Double {
         return totalExpectedTime / Double(routeCoordinates.count)
     }
     var totalTraveledtime: Double {
         return expectedTravelTimePerCoordinates * Double(currentLocationIndex)
     }
     var totalExpectedTime: Double {
         return route?.expectedTravelTime ?? 0.0
     }
     var routeSteps: [RouteStep] {
         if let route {
            return route.steps.map { RouteStep(step: $0) }
         }
         return []
     }
     var nextStep: MKRoute.Step? {
         var calculatedTime = 0.0
         for step in routeSteps{
             if totalTraveledtime <= calculatedTime {
                 return step.step
             }
             calculatedTime += expectedTimeForStep(step.step)
         }
         return nil
     }
     
     var timer: Timer?
     var currentLocationIndex: Int = 0
     
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
     
     func incrementCurrentLocationIndex() {
         if currentLocationIndex < routeCoordinates.count - 1 {
             currentLocationIndex += 1
         }
     }
     
     func resetCurrentLocationIndex() {
         currentLocationIndex = .zero
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
                                                      coordinate: coordinate,mapItem: item)
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
                              to destination: CLLocationCoordinate2D,
                              completion: @escaping(MKRoute) -> Void) {
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
             self.route = route
             self.routeCoordinates = route.steps.flatMap(\.polyline.mkCoordinates)
             // ----------- Code required to generate coordinates ---------
             route.polyline.printGPXCoordinatesForRoute()
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
     
     /// Gets the `MKLookAroundScene` for a map item after loading it asynchronously if necessary.
     /// - parameter mapItem: The  map item.
     func lookAroundScene(for mapItem: MKMapItem) {
         let sceneRequest = MKLookAroundSceneRequest(mapItem: mapItem)
         sceneRequest.getSceneWithCompletionHandler { scene, error in
             if let error {
                 print("Debug: \(mapItem.placemark.title ?? "")====\(error)")
                 self.lookAroundScene = nil
                 return
             }
             DispatchQueue.main.async {
                 self.lookAroundScene = scene
             }
         }
     }

     func expectedTimeForStep(_ step: MKRoute.Step) -> Double {
         if let route, totalExpectedTime != 0{
             return (totalExpectedTime / route.distance) * step.distance
         }
         return 0.0
     }
     
     func resetMap() {
         LiveActivityManager().stop()
         if let timer {
             timer.invalidate()
             self.timer = nil
         }
         lookAroundScene = nil
     }
 }

 // MARK: - MKLocalSearchCompleterDelegate

 extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
     func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
         self.results = completer.results
     }
 }

// MARK: - LiveActivity Life-Cycle Methods
extension LocationSearchViewModel {
    /// Functions to handle live activities
    func startLiveActivity() {
        guard let step = nextStep else {return}
        LiveActivityManager().start(timeInterval: totalExpectedTime - totalTraveledtime, instruction: step.instructions, distance: step.distance)
    }
    
    func updateLiveActivity() {
        guard let step = nextStep else {return}
        LiveActivityManager().update(timeInterval: totalExpectedTime - totalTraveledtime, instruction: step.instructions, distance: step.distance)
    }
    
    func endLiveActivity() {
        LiveActivityManager().stop()
    }
}
