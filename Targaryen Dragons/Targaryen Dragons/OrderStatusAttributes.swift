//
//  OrderStatusAttributes.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 27/10/22.
//

import Foundation
import ActivityKit

struct OrderStatusAttributes: ActivityAttributes {
    public typealias OrderStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var driverName: String
        var estimatedDeliveryTime: Date
        var direction: Direction
        var instruction: String
    }

    var numberOfItems: Int
    var customerNumber: String
    var id = UUID()
    var startedTime: Date
}

enum Direction: String, Codable{
    case left
    case right
    case straight
}

extension Direction {
    var directionImage: String {
        switch(self){
        case .left:
            return "arrow.turn.up.left"
        case .right:
            return "arrow.turn.up.right"
        case .straight:
            return "arrow.up"
        }
    }
    
    static func getDirectionFromInstruction(_ instruction: String) -> Direction {
        if instruction.contains((/left/.ignoresCase())){
            return .left
        } else if instruction.contains((/right/.ignoresCase())){
            return .right
        } else {
            return .straight
        }
    }
}
