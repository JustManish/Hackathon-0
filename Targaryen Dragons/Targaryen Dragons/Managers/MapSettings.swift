//
//  MapSettings.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI

final class MapSettings: ObservableObject {
    @Published var mapType = 0
    @Published var showElevation = 0
    @Published var showEmphasisStyle = 0
}
