//
//  Targaryen_DragonsApp.swift
//  Targaryen Dragons
//
//  Created by Nasir Ahmed Momin on 27/10/22.
//

import SwiftUI

@main
 struct Targaryen_DragonsApp: App {

     @StateObject var locationViewModel = LocationSearchViewModel()

     let center = UNUserNotificationCenter.current()
     
     init() {
         registerForNotification()
     }
     
     func registerForNotification() {
         UIApplication.shared.registerForRemoteNotifications()
         let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
         center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
             if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
             else {
                 
             }
         })
     }
     
     var body: some Scene {
         WindowGroup {
             HomeView()
                 .environmentObject(locationViewModel)
                 .onOpenURL { url in
                     guard let url = URLComponents(string: url.absoluteString) else { return }
                     if let courierNumber = url.queryItems?.first(where: { $0.name == "number" })?.value {
                         //TODO: when delivery agent reached to destination call customer
                     }
                 }
         }
     }
 }
