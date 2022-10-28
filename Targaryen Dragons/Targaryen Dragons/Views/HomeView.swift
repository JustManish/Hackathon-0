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
                 MapView(mapState: $mapState)
                     .ignoresSafeArea()

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
             
             HStack {
                 Spacer()
                 Button {
                    // TODO: handle current location
                 } label: {
                     Image(systemName: "location.circle")
                         .imageScale(.large)
                         .foregroundColor(.red)
                 }
                 .padding(.bottom, 50.0)
                 .padding(.trailing, 50.0)
             }
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
