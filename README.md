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

user-images.githubusercontent.com/105850771/198895996-63ec0a08-9cda-439c-9e0c-ef7bf5b656ed.mov

https://![Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 23 45](https://user-images.githubusercontent.com/102941982/198921348-d95146d6-17db-4cd![Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 28 34](https://user-images.githubusercontent.com/102941982/198921914-cd36186a-f5bc-4b69-94f0-73278f4257e1.png)
7-9696-2b5f2![Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 30 33](https://user-images.githubusercontent.com/102941982/198922116-75042def-b528-4d24-9668-bea88740bc0a.png)
645ad6d.png)
![S![Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 34 59](https://user-images.githubusercontent.com/102941982/198922675-4850cacf-b8eb-4e35-b51e-5f0ee550de8b.png)
![Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 35 22](https://user-images.githubusercontent.com/102941982/198922684-e181c84b-a311-4508-94b1-0d3f9cfe3917.png)
im![![Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 33 14](https://user-images.githubusercontent.com/102941982/198922477-5ff5b9cb-2926-424f-b23e-bf483d4d76a6.png)
![Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 33 19](https://user-images.githubusercontent.com/102941982/198922436-0ffd1ca1-2e04-4fd8-bcd7-5c2372314624.png)
Simulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 32 27](https://user-images.githubusercontent.com/102941982/198922342-94a9e9a5-bf8d-469c-8c1f-488b1d296456.png)
ulator Screen Shot - iPhone 14 Pro Max - 2022-10-31 at 08 31 46](https://user-images.githubusercontent.com/102941982/198922267-e852c8a3-ba31-4b38-87c0-ac747615d575.png)
