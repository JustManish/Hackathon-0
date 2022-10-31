//
//  Double+Extension.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 31/10/22.
//

import Foundation

extension Double {
    
    var distanceString: String {
        self > 1000 ? "\((self / 1000).rounded(toPlaces:2)) KM" : "\(self.rounded(toPlaces:2)) M"
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
