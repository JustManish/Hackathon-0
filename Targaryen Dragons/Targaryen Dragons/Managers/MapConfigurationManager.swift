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
    @Published var mapType: MapConfigurationType = .standard(elevationType: .realistic,
                                                             emphasisStyle: ._default)
    
    static let shared: MapConfiguartionManager = MapConfiguartionManager()
    
    func updateMapConfigType(_ type: MapConfigurationType) {
        self.mapType = type
    }
}
