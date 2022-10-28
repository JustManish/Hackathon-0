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

     var body: some Scene {
         WindowGroup {
             HomeView()
                 .environmentObject(locationViewModel)
         }
     }
 }
