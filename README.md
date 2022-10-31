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

## Screenshots

1. ![First](https://user-images.githubusercontent.com/105850771/198929631-08d9a208-7dfa-447f-8f31-98e0e9651691.png)

2. ![Second](https://user-images.githubusercontent.com/105850771/198929653-479d9c13-70a9-430d-bade-58a6be2b2073.png)

3. ![Third](https://user-images.githubusercontent.com/105850771/198929699-2ad49d66-3064-4b1e-8a24-37dd611178cc.png)

4. ![Fourth](https://user-images.githubusercontent.com/105850771/198929677-777ca096-9b14-4fd5-92f7-fc32cf9935a0.png)

5. ![Fifth](https://user-images.githubusercontent.com/105850771/198929749-76215a32-2351-4ad4-a661-e2dcb502bf4d.png)

6. ![Sixth](https://user-images.githubusercontent.com/105850771/198929747-4faf6e04-1c6b-4c75-9f80-847efbb09dc2.png)

7. ![Seventh](https://user-images.githubusercontent.com/105850771/198929746-4d12c6ee-e858-4ff6-bd11-de5893c8c12b.png)

8. ![Eight](https://user-images.githubusercontent.com/105850771/198929723-c67a9611-321d-4150-8dda-263a975224b2.png)

9. ![Nine](https://user-images.githubusercontent.com/105850771/198929737-ee03ad82-4fae-4ac1-8d8e-239bc631a0a3.png)

10. ![Ten](https://user-images.githubusercontent.com/105850771/198929741-6f6ab45a-6311-400b-beff-a595286ba71c.png)






