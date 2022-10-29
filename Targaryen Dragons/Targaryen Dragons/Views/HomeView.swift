//
 //  HomeView.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import SwiftUI

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                GeometryReader { geometry in
                    MapView(mapState: $mapState)
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
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
                
                DynamicActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            if mapState == .polylineAdded && locationViewModel.lookAroundScene != nil{
                HStack {
                    LookAroundView()
                        .frame(width: 165,height: 100,alignment: .bottomLeading)
                        .cornerRadius(5)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    Spacer()
                }
                .padding(10)
            }
            HStack(alignment: .bottom) {
                if mapState == .mapSettingShown {
                    MapConfigurationView()
                }
                Spacer(minLength: 10)
                VStack {
                    Button {
                        // TODO: handle current location
                    } label: {
                        Image(systemName: "location.circle")
                            .imageScale(.large)
                            .foregroundColor(.red)
                    }
                    Button {
                        if mapState == .mapSettingShown {
                            mapState = .noInput
                        } else {
                            mapState = .mapSettingShown
                        }
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                }
            }
            .padding(10)
            .padding(.bottom, 30.0)
            .padding(.trailing, 20.0)
            if mapState == .locationSelected || mapState == .polylineAdded {
                //TODO: Action
            }
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
