//
 //  LocationSearchViewModel.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import Foundation
 import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var route: MKRoute?
    @Published var selectedLocation: DragonLocation?
    @Published var expectedArrivalTime: String?
    @Published var lookAroundScene : MKLookAroundScene?
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    
    var timer: Timer?
    var currentLocationIndex: Int = 0
    var userLocation: CLLocationCoordinate2D?
    
    var routeSteps: [RouteStep] {
        if let route {
            return route.steps.map { RouteStep(step: $0) }
        }
        return []
    }
    
    var nextStep: MKRoute.Step? {
        var calculatedTime = 0.0
        for step in routeSteps{
            if totalTraveledTime <= calculatedTime {
                return step.step
            }
            calculatedTime += expectedTimeForStep(step.step)
        }
        return nil
    }
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    private let liveActivityManager = LiveActivityManager()
    private let searchCompleter = MKLocalSearchCompleter()
    
    private var expectedTravelTimePerCoordinates: Double {
        return totalExpectedTime / Double(routeCoordinates.count)
    }
    
    private var totalTraveledTime: Double {
        return expectedTravelTimePerCoordinates * Double(currentLocationIndex)
    }
    
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
            route.polyline.printGPXCoordinatesForRoute()
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
    
    private var totalExpectedTime: Double {
        return route?.expectedTravelTime ?? 0.0
    }
    
    func expectedTimeForStep(_ step: MKRoute.Step) -> Double {
        if let route, totalExpectedTime != .zero {
            return (totalExpectedTime / route.distance) * step.distance
        }
        return 0.0
    }
    
    func resetMap() {
        stopNavigation()
        lookAroundScene = nil
    }
    
    func updatePropertiesOnTimer() {
        currentLocationIndex == .zero ? startLiveActivity() : updateLiveActivity()
        incrementCurrentLocationIndex()
        if currentLocationIndex == routeCoordinates.count - 1 {
            stopNavigation()
            resetCurrentLocationIndex()
        }
    }
    
    func stopNavigation() {
        timer?.invalidate()
        timer = nil
        resetCurrentLocationIndex()
        endLiveActivity()
    }
    
    func checkAndDismissLiveActivity() {
        if let _ = timer {
            endLiveActivity()
        }
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
        let timeInterval = totalExpectedTime - totalTraveledTime
        let estimatedTime: Date = Date().addingTimeInterval(timeInterval)
        
        liveActivityManager.start(estimatedTime: estimatedTime,
                                  instruction: step.instructions,
                                  distance: step.distance)
    }
    
    func updateLiveActivity() {
        guard let step = nextStep else {return}
        let timeInterval = totalExpectedTime - totalTraveledTime
        let estimatedTime: Date = Date().addingTimeInterval(timeInterval)
        liveActivityManager.update(estimatedTime: estimatedTime,
                                   instruction: step.instructions,
                                   distance: step.distance)
    }
    
    func endLiveActivity() {
        LiveActivityManager().stop()
    }
}
