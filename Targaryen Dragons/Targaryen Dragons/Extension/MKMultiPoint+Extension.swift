//
//  MKMultiPoint+Extension.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 30/10/22.
//

import Foundation
import MapKit

extension MKMultiPoint {
    
  var mkCoordinates: [CLLocationCoordinate2D] {
    var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                       count: pointCount)
    getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
    return coords
  }
    
    func printGPXCoordinatesForRoute() {
        var coordinates = ""
        for (index, item) in mkCoordinates.enumerated() {
            
            let gpx = """
                       <wpt lat="\(item.latitude)" lon="\(item.longitude)">
                           <name> Point \(index) </name>
                       </wpt>
                      
              """
            
            coordinates.append(gpx)
        }
        print("GPX route:\n \(coordinates)")
    }
}
