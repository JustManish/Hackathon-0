//
//  OrderStatusLiveActivityManager.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 27/10/22.
//

import Foundation
import ActivityKit

struct LiveActivityManager {
    
    let attributes: OrderStatusAttributes
    let orderStatus: OrderStatusAttributes.OrderStatus
    
    // MARK: - Lifecycle Methods
    
    func start() {
        let attributes = OrderStatusAttributes(numberOfItems: 1,
                                               totalAmount:"$99")

        let initialContentState = OrderStatusAttributes.OrderStatus(driverName: "John 👨🏻‍🍳", estimatedDeliveryTime: Date()...Date().addingTimeInterval(15 * 60))
                                                  
        do {
            let deliveryActivity = try Activity<OrderStatusAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil)
            print("Requested a order status Live Activity \(deliveryActivity.id)")
        } catch (let error) {
            print("Error requesting order status Live Activity \(error.localizedDescription)")
        }
    }
    
    func update() {
        Task {
            let updatedDeliveryStatus = OrderStatusAttributes.OrderStatus(driverName: "John 👨🏻‍🍳", estimatedDeliveryTime: Date()...Date().addingTimeInterval(60 * 60))
            
            for activity in Activity<OrderStatusAttributes>.activities{
                await activity.update(using: updatedDeliveryStatus)
            }
        }
    }
    
    func stop() {
        Task {
            for activity in Activity<OrderStatusAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
    
    func showAllDeliveries() {
        Task {
            for activity in Activity<OrderStatusAttributes>.activities {
                print("delivery details: \(activity.id) -> \(activity.attributes)")
            }
        }
    }
}
