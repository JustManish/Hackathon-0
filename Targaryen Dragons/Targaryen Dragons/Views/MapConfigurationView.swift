//
//  MapSettingView.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI

struct MapConfigurationView: View {
    
    @State private var elevationType: MapElevationType = .realistic
    @State private var emphesisStyle: EmphasisStyle = ._default
    @State var mapType: MapConfigurationType = .standard(elevationType: .realistic, emphasisStyle: ._default)
    
    @StateObject var mapSettings: MapConfiguartionManager = MapConfiguartionManager.shared
    
    var body: some View {
        VStack {
            Picker("Map Type", selection: $mapType) {
                Text("Standard").tag(MapConfigurationType.standard(elevationType: .realistic,
                                                                   emphasisStyle: ._default))
                Text("Hybrid").tag(MapConfigurationType.hybrid(elevationType: .realistic,
                                                               emphasisStyle: ._default))
                Text("Image").tag(MapConfigurationType.image(elevationType: .realistic,
                                                             emphasisStyle: ._default))
            }.pickerStyle(SegmentedPickerStyle())
                .padding([.top, .leading, .trailing], 16)
            
            Picker("Map Elevation", selection: $elevationType) {
                Text("Realistic").tag(MapElevationType.realistic)
                Text("Flat").tag(MapElevationType.flat)
            }.pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing], 16)
            
            Picker("Emphasis Style", selection: $emphesisStyle) {
                Text("Default").tag(EmphasisStyle._default)
                Text("Muted").tag(EmphasisStyle.muted)
            }.pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing], 16)
        }
        .onChange(of: mapType) { newValue in
            let new = newValue.changeConfig(type: mapType,
                                            elevation: elevationType,
                                            style: emphesisStyle)
            mapSettings.mapType = new
        }
        .onChange(of: elevationType) { newValue in
            let new = mapType.changeConfig(type: mapType,
                                           elevation: elevationType,
                                           style: emphesisStyle)
            mapSettings.mapType = new
        }
        .onChange(of: emphesisStyle) { newValue in
            let new = mapType.changeConfig(type: mapType,
                                           elevation: elevationType,
                                           style: emphesisStyle)
            mapSettings.mapType = new
        }
        .padding(10)
        .background(.black.opacity(0.6))
        .cornerRadius(5)
    }
}
