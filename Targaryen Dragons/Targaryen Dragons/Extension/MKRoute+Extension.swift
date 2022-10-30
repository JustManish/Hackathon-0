//
//  MKRoute+Extension.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 29/10/22.
//

import Foundation
import MapKit

extension MKRoute {
    
     func printGPXCoordinatesForRoute() {
        var coordinates = ""
         for (index, item) in steps.enumerated() {
            
            let gpx = """
                        <wpt lat="\(item.polyline.coordinate.latitude)" lon="\(item.polyline.coordinate.longitude)">
                            <name> Point \(index) </name>
                        </wpt>
                       
               """
            
            coordinates.append(gpx)
        }
        print("GPX route:\n \(coordinates)")
    }
}
