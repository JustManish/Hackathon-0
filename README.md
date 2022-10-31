# Targaryen-Dragons
## Hackathon 2022

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://mutualmobile.com)

## Idea: 
Utilized `MapKit` and `Live Activities` to show Map which support different Map Configuration(`Standard, Hybrid, Image`) with different Elevation(`.realistic, .flat`) and emphasis(`.default, .muted`) style and Live Route Tracking with Look `Around 3-D View` at available places and showing updates of Route Tracking as `Live Activity on Lock screen & on Dynamic Island`.

## Features
- Different Map Configuration
- Live Route Tracking from source location to destination.
- Look Around 3D View for supported Locations.
- Simulate Route Tracking Updates like Estimated Time of Arrival and Directions in Live Activity.
- List of direction instructions from source to destination route.

## Limitations 
- supports only on iOS 16.1 and onward devices, because Live Activity is available in iOS 16.1 onwards devices.
- For Testing in simulator GPX file is used to get fixed route coordinates for Live Location tracking in map.
- Information show in Live Activity are just simulation from Live Route Track and not any business information.

## Tech

Below listed Frameworks are used from iOS SDK.
- MapKit: https://developer.apple.com/documentation/mapkit/
- ActivityKit: https://developer.apple.com/documentation/activitykit
- SwiftUI
- Foundation.

## Resources Used

- https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
- https://medium.com/swlh/simulating-dynamic-locations-with-xcode-c72ccfacef9e
- https://www.kodeco.com/7738344-mapkit-tutorial-getting-started!
- https://holyswift.app/new-mapkit-configurations-with-swiftui/
- https://developer.apple.com/documentation/mapkit/explore_a_location_with_a_highly_detailed_map_and_look_around

## Issues
- Background Task from Live Activity is not working like once destination reached Live Activity is not Auto stopping. 
https://github.com/spaceotech/BackgroundTask/issues/2

## Demo
[+user-images.githubusercontent.com/105850771/198895996-63ec0a08-9cda-439c-9e0c-ef7bf5b656ed.mov](https://user-images.githubusercontent.com/105850771/198895996-63ec0a08-9cda-439c-9e0c-ef7bf5b656ed.mov)
