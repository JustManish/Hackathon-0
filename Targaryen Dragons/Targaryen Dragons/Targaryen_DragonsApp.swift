//
//  Targaryen_DragonsApp.swift
//  Targaryen Dragons
//
//  Created by Nasir Ahmed Momin on 27/10/22.
//

import SwiftUI
import BackgroundTasks

@main
struct Targaryen_DragonsApp: App {
    
    @StateObject var locationViewModel = LocationSearchViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    let center = UNUserNotificationCenter.current()
    
    init() {
        registerForNotification()
    }
    
    func registerForNotification() {
        UIApplication.shared.registerForRemoteNotifications()
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
            if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
            else {
                
            }
        })
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
                .onOpenURL { url in
                    guard let url = URLComponents(string: url.absoluteString) else { return }
                    if let courierNumber = url.queryItems?.first(where: { $0.name == "number" })?.value {
                        //when delivery agent reached to destination call customer
                        let phone = "tel://"
                        let phoneNumberformatted = phone + courierNumber
                        guard let url = URL(string: phoneNumberformatted) else { return }
                        UIApplication.shared.open(url)
                    }
                }
        }
        .onChange(of: scenePhase) { phase in
                            switch phase {
                            case .background:
                                scheduleAppRefresh()
                                print("background")
                            case .active:
                                print("active")
                                BGTaskScheduler.shared.getPendingTaskRequests(completionHandler: { request in
                                    print("Pending task requests: \(request)")
                                })
                            case .inactive:
                                print("inactive")
                            @unknown default:
                                break
                            }
                        }
        .backgroundTask(.appRefresh("liveactivity")){
            await updateLiveActivityOnBackground()
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "liveactivity")
        request.earliestBeginDate = .now.addingTimeInterval(10)
        do{
            try BGTaskScheduler.shared.submit(request)
        } catch(let error){
            print("error ==== \(error)")
        }
    }
    
    func updateLiveActivityOnBackground() {
        if(locationViewModel.currentLocationIndex > 0 && locationViewModel.timer != nil){
            print("bg task validated")
            scheduleAppRefresh()
            locationViewModel.updatePropertiesOnTimer()
        }
    }
}
