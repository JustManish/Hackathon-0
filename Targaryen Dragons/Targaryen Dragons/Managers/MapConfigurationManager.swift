//
//  MapSettings.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI
import MapKit

enum MapConfigurationType: Hashable {
    case standard(elevationType: MapElevationType, emphasisStyle: EmphasisStyle)
    case hybrid(elevationType: MapElevationType, emphasisStyle: EmphasisStyle)
    case image(elevationType: MapElevationType, emphasisStyle: EmphasisStyle)
    
    func changeConfig(type: MapConfigurationType, elevation: MapElevationType,
                      style: EmphasisStyle) -> MapConfigurationType  {
        
        switch type {
        case .standard(_, _):
            return .standard(elevationType: elevation, emphasisStyle: style)
        case .hybrid(_, _):
            return .hybrid(elevationType: elevation, emphasisStyle: style)
        case .image(_, _):
            return .image(elevationType: elevation, emphasisStyle: style)
        }
    }
}

enum MapElevationType {
    case flat
    case realistic
    
    var value: MKMapConfiguration.ElevationStyle {
        switch self {
        case .realistic:
            return MKMapConfiguration.ElevationStyle.realistic
        case .flat:
            return MKMapConfiguration.ElevationStyle.flat
        }
    }
}

enum EmphasisStyle {
    case _default
    case muted
    
    var value: MKStandardMapConfiguration.EmphasisStyle {
        switch self {
        case ._default:
            return MKStandardMapConfiguration.EmphasisStyle.default
        case .muted:
            return MKStandardMapConfiguration.EmphasisStyle.muted
        }
    }
}


final class MapConfiguartionManager: ObservableObject {
    
    static var defaultMapConfig: MKMapConfiguration {
        let configuration = MKStandardMapConfiguration(elevationStyle: .realistic,
                                                       emphasisStyle: .default)
        configuration.pointOfInterestFilter = MKPointOfInterestFilter(including: [.atm,.airport,.beach,.nationalPark])
        configuration.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.bakery])
        configuration.showsTraffic = false
        return configuration
    }
    
    @Published var isMapConfigurationVisible: Bool = false
    @Published var mapConfig: MKMapConfiguration = MapConfiguartionManager.defaultMapConfig
    
    static let shared: MapConfiguartionManager = MapConfiguartionManager()
    
    func updateMapConfigType(_ type: MapConfigurationType) {
        switch type {
        case .standard(let elevation, let style):
            let configuration = MKStandardMapConfiguration(elevationStyle: elevation.value,
                                                           emphasisStyle: style.value)
            configuration.pointOfInterestFilter = MKPointOfInterestFilter(including: [.atm,.airport,.beach,.nationalPark])
            configuration.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.bakery])
            configuration.showsTraffic = false
            mapConfig = configuration
        case .hybrid(let elevation, _):
            mapConfig = MKHybridMapConfiguration(elevationStyle: elevation.value)// this uses satelite images and road names, can se the globe in realistic
        case .image(let elevation, _):
            mapConfig = MKImageryMapConfiguration(elevationStyle: elevation.value) //flat - just images dont see the globe, realistic 3D realistic building can see the globe
        }
    }
}
