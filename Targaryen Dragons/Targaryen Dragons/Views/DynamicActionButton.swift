//
 //  DynamicActionButton.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import SwiftUI

 struct DynamicActionButton: View {
     @Binding var mapState: MapViewState
     @EnvironmentObject var viewModel: LocationSearchViewModel

     var body: some View {
         Button {
             withAnimation(.spring()) {
                 actionForState(mapState)
             }
         } label: {
             Image(systemName: imageNameForState(mapState))
                 .font(.title2)
                 .foregroundColor(.black)
                 .padding()
                 .background(.white)
                 .clipShape(Circle())
                 .shadow(color: .black, radius: 6)
         }
         .frame(maxWidth: .infinity, alignment: .leading)
     }

     func actionForState(_ state: MapViewState) {
         switch state {
         case .noInput:
             print("DEBUG: No input")
         case .searchingForLocation:
             mapState = .noInput
         case .locationSelected, .polylineAdded, .mapSettingShown:
             mapState = .noInput
             viewModel.selectedLocation = nil
         }
     }

     func imageNameForState(_ state: MapViewState) -> String {
         switch state {
         case .noInput:
             return "line.3.horizontal"
         case .searchingForLocation, .locationSelected, .polylineAdded, .mapSettingShown:
             return "arrow.left"
         }
     }
 }

 struct DynamicActionButton_Previews: PreviewProvider {
     static var previews: some View {
         DynamicActionButton(mapState: .constant(.noInput))
     }
 }
