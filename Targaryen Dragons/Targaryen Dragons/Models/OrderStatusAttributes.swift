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
        var estimatedDeliveryTime: ClosedRange<Date>
    }

    var numberOfItems: Int
    var totalAmount: String
}
