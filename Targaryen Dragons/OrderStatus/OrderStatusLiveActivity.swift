//
//  OrderStatusLiveActivity.swift
//  OrderStatus
//
//  Created by Manish Patidar on 27/10/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderStatusAttributes.self) { context in
            LockScreenView(context: context)
                .activityBackgroundTint(Color.cyan)
                .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    dynamicIslandExpandedLeadingView(context: context)
                 }
                 
                 DynamicIslandExpandedRegion(.trailing) {
                     dynamicIslandExpandedTrailingView(context: context)
                 }
                 
                 DynamicIslandExpandedRegion(.center) {
                     dynamicIslandExpandedCenterView(context: context)
                 }
                 
                DynamicIslandExpandedRegion(.bottom) {
                    dynamicIslandExpandedBottomView(context: context)
                }
                
              } compactLeading: {
                  compactLeadingView(context: context)
              } compactTrailing: {
                  compactTrailingView(context: context)
              } minimal: {
                  minimalView(context: context)
              }
              .widgetURL(URL(string: "targaryandragon://targaryen?number=\(context.attributes.customerNumber)"))
              .keylineTint(Color.red)
        }
    }
    
    
    //MARK: Expanded Views
    func dynamicIslandExpandedLeadingView(context: ActivityViewContext<OrderStatusAttributes>) -> some View {
        VStack {
            Label {
                Text("\(context.state.instruction)")
                    .font(.title2)
            } icon: {
                Image(systemName: context.state.direction.directionImage)
                    .foregroundColor(.green)
            }
        }
    }
    
    
    
    func dynamicIslandExpandedTrailingView(context: ActivityViewContext<OrderStatusAttributes>) -> some View {
        Label {
            Text(context.state.estimatedDeliveryTime, style: .timer)
                .multilineTextAlignment(.trailing)
                .frame(width: 50)
                .monospacedDigit()
        } icon: {
            Image(systemName: "timer")
                .foregroundColor(.green)
        }.font(.caption2)
    }
    
    func dynamicIslandExpandedBottomView(context: ActivityViewContext<OrderStatusAttributes>) -> some View {
        let url = URL(string: "targaryandragon://targaryen?number=\(context.attributes.customerNumber)")
        return Link(destination: url!) {
            Label("Call customer", systemImage: "phone")
        }.foregroundColor(.green)
    }
    
    func dynamicIslandExpandedCenterView(context: ActivityViewContext<OrderStatusAttributes>) -> some View {
        Text("Hey \(context.state.driverName) drive safe!")
            .lineLimit(1)
            .font(.caption)
    }
    
    
    //MARK: Compact Views
    func compactLeadingView(context: ActivityViewContext<OrderStatusAttributes>) -> some View {
        VStack {
            Label {
                Text(context.state.instruction)
                    .font(.caption2)
            } icon: {
                Image(systemName: context.state.direction.directionImage)
                    .foregroundColor(.green)
            }
        }
    }
    
    func compactTrailingView(context: ActivityViewContext<OrderStatusAttributes>) -> some View {
        Text(context.state.estimatedDeliveryTime, style: .timer)
            .multilineTextAlignment(.center)
            .frame(width: 40)
            .font(.caption2)
    }
    
    func minimalView(context: ActivityViewContext<OrderStatusAttributes>) -> some View {
        VStack(alignment: .center) {
            Image(systemName: "timer")
            Text(context.state.estimatedDeliveryTime, style: .timer)
                .multilineTextAlignment(.center)
                .monospacedDigit()
                .font(.caption2)
        }
    }
}

struct LockScreenView: View {
    var context: ActivityViewContext<OrderStatusAttributes>
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .center) {
                    Text("Hey \(context.state.driverName) drive safe!").font(.headline)
                    HStack {
                        Text("After \(context.state.instruction) take \(context.state.direction.rawValue.capitalized)")
                            .font(.title2)
                        Image(systemName: context.state.direction.directionImage)
                            .foregroundColor(.green)
                            .bold()
                    }
                    .font(.subheadline)
                    
                    BottomLineView(startedTime: context.state.startedTime,
                                   remainingTime: context.state.estimatedDeliveryTime,
                                   number: context.attributes.customerNumber)
                }
            }
        }.padding(15)
    }
}

struct BottomLineView: View {
    var startedTime: Date
    var remainingTime: Date
    let number: String
    var body: some View {
        HStack {
            Image("delivery")
            VStack {
                ProgressView(timerInterval: remainingTime...startedTime)
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 1,
                                               dash: [4]))
                    .frame(height: 10)
//                    .overlay(Text(remainingTime, style: .timer)
//                        .font(.system(size: 8))
//                        .multilineTextAlignment(.center))
            }
            Image("home-address")
            Link(destination: URL(string: "targaryandragon://targaryen?number=\(number)")!) {
                Image(systemName:"phone.circle")
            }.foregroundColor(.green)
        }
    }
}
