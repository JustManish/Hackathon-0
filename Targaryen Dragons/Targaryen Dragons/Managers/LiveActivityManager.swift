//
//  OrderStatusLiveActivityManager.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 27/10/22.
//

import Foundation
import ActivityKit

struct LiveActivityManager {
//    static let shared = LiveActivityManager()
//    private init() {}
    
//    let attributes: OrderStatusAttributes
//    let orderStatus: OrderStatusAttributes.OrderStatus
    
    // MARK: - Lifecycle Methods
    
    func start(timeInterval:Double, instruction: String, distance: Double) {
        let attributes = OrderStatusAttributes(numberOfItems: 1,
                                               customerNumber: "8249406457")

        let initialContentState = OrderStatusAttributes.OrderStatus(driverName: "John", estimatedDeliveryTime: Date().addingTimeInterval(timeInterval),direction: Direction.getDirectionFromInstruction(instruction),instruction: distance.distanceString)
                                                  
        do {
            let deliveryActivity = try Activity<OrderStatusAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil)
            print("Requested a order status Live Activity \(deliveryActivity.id)")
            //deliveryActivity.activityStateUpdates to check the status
        } catch (let error) {
            print("Error requesting order status Live Activity \(error.localizedDescription)")
        }
    }
    
    func update(timeInterval:Double, instruction: String, distance: Double) {
        Task {
            let updatedDeliveryStatus = OrderStatusAttributes.OrderStatus(driverName: "John", estimatedDeliveryTime: Date().addingTimeInterval(timeInterval),direction: Direction.getDirectionFromInstruction(instruction),instruction: distance.distanceString)
            
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

extension Double {
    var distanceString: String {
        if self > 1000 {
            return "\((self / 1000).rounded(toPlaces:2)) KM"
        } else {
            return "\(self.rounded(toPlaces:2)) M"
        }
    }
    func rounded(toPlaces places:Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return (self * divisor).rounded() / divisor
        }
}
