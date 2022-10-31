//
//  OrderStatusLiveActivityManager.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 27/10/22.
//

import Foundation
import ActivityKit

struct LiveActivityManager {
    
    // MARK: - Lifecycle Methods
    
    func start(estimatedTime: Date,
               instruction: String,
               distance: Double) {

        let attributes = OrderStatusAttributes(numberOfItems: 1,
                                               customerNumber: "8249406457",
                                               startedTime: Date())

        let direction = Direction.getDirectionFromInstruction(instruction)
        let initialContentState = OrderStatusAttributes.OrderStatus(driverName: "John",
                                                                    estimatedDeliveryTime: estimatedTime,
                                                                    direction: direction,
                                                                    instruction: distance.distanceString)
                                                  
        do {
            let deliveryActivity = try Activity<OrderStatusAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil)
            debugPrint("Requested a order status Live Activity \(deliveryActivity.id)")
            //deliveryActivity.activityStateUpdates to check the status
        } catch (let error) {
            debugPrint("Error requesting order status Live Activity \(error.localizedDescription)")
        }
    }
    
    func update(estimatedTime: Date,
                instruction: String,
                distance: Double) {
        
        Task {
            let direction = Direction.getDirectionFromInstruction(instruction)
            let updatedDeliveryStatus = OrderStatusAttributes.OrderStatus(driverName: "John",
                                                                          estimatedDeliveryTime: estimatedTime,
                                                                          direction: direction,
                                                                          instruction: distance.distanceString)
            
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
                debugPrint("delivery details: \(activity.id) -> \(activity.attributes)")
            }
        }
    }
}
