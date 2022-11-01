//
//  HomeView.swift
//  Targaryen Dragons
//
//  Created by Manish Patidar on 28/10/22.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @State var isDirectionListVisible = false
    @StateObject var mapConfigManager: MapConfiguartionManager = MapConfiguartionManager.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                GeometryReader { geometry in
                    MapView(mapState: $mapState)
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width,
                               height: geometry.size.height,
                               alignment: .center)
                }
                if mapState == .searchingForLocation {
                    LocationSearchListView(mapState: $mapState)
                } else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 88)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                HStack {
                    DynamicActionButton(mapState: $mapState)
                    if mapState == .polylineAdded {
                        SystemImageActionButton(imageName: "arrow.triangle.branch") {
                            isDirectionListVisible.toggle()
                        }
                    }
                }
                .padding(.leading)
                .padding(.top, 4)
                .padding(.trailing, 60)
            }
            if mapState == .polylineAdded && locationViewModel.lookAroundScene != nil {
                HStack {
                    MapLookAroundView()
                        .frame(width: 165, height: 100, alignment: .bottomLeading)
                        .cornerRadius(5)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    Spacer()
                }
                .padding(30)
            }
            HStack(alignment: .bottom) {
                    MapConfigurationView()
                        //.animation(.easeIn, value: mapConfigManager.isMapConfigurationVisible)
                        .opacity(mapConfigManager.isMapConfigurationVisible ? 1.0 : .zero)
                Spacer(minLength: 10)
                VStack(spacing: 12) {
                    Button {
                        // TODO: handle current location
                    } label: {
                        Image(systemName: "location.circle")
                            .imageScale(.large)
                            .foregroundColor(.red)
                    }
                    Button {
                        mapConfigManager.isMapConfigurationVisible.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                }
                .opacity(mapState == MapViewState.searchingForLocation ||
                         mapState == MapViewState.startNavigating ? .zero : 1.0)
            }
            .padding(10)
            .padding(.bottom, 30.0)
            if mapState == .locationSelected || mapState == .polylineAdded {
                //TODO: Action
            }
        }
        .onAppear(perform: {
            locationViewModel.checkAndDismissLiveActivity()
        })
        .sheet(isPresented: $isDirectionListVisible) {
            DirectionsListView()
                .presentationDetents([.tiny, .medium, .large])
                .presentationDragIndicator(.automatic)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
