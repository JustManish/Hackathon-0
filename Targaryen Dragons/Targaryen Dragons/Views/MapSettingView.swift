//
//  MapSettingView.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI

struct MapSettingView: View {
    @State var mapType = 0
    @State var showElevation = 0
    @State var showEmphasis = 0
    
    @EnvironmentObject var mapSettings: MapSettings
    
    var body: some View {
        VStack {
            Picker("Map Type", selection: $mapType) {
                Text("Standard").tag(0)
                Text("Hybrid").tag(1)
                Text("Image").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
                .onChange(of: mapType) { newValue in
                    mapSettings.mapType = newValue
                }.padding([.top, .leading, .trailing], 16)
            
            Picker("Map Elevation", selection: $showElevation) {
                Text("Realistic").tag(0)
                Text("Flat").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
                .onChange(of: showElevation) { newValue in
                    mapSettings.showElevation = newValue
                }.padding([.leading, .trailing], 16)
            
            Picker("Map Elevation", selection: $showEmphasis) {
                Text("Default").tag(0)
                Text("Muted").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
                .onChange(of: showEmphasis) { newValue in
                    mapSettings.showEmphasisStyle = newValue
                }.padding([.leading, .trailing], 16)
            
        }.padding(10)
            .background(.black.opacity(0.6))
            .cornerRadius(5)
    }
    
}
