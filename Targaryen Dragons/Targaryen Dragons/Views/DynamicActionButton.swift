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
         SystemImageActionButton(imageName: imageNameForState(mapState)) {
             actionForState(mapState)
         }
         .frame(maxWidth: .infinity, alignment: .leading)
     }

     func actionForState(_ state: MapViewState) {
         switch state {
         case .noInput:
             print("DEBUG: No input")
         case .searchingForLocation:
             mapState = .noInput
         case .locationSelected, .mapSettingShown, .startNavigating:
             mapState = .noInput
             viewModel.selectedLocation = nil
         case .polylineAdded:
             mapState = .startNavigating
         }
     }

     func imageNameForState(_ state: MapViewState) -> String {
         switch state {
         case .noInput:
             return "line.3.horizontal"
         case .searchingForLocation, .locationSelected, .startNavigating, .mapSettingShown:
             return "arrow.left"
         case .polylineAdded:
             return "arrow.right"
         }
     }
 }

 struct DynamicActionButton_Previews: PreviewProvider {
     static var previews: some View {
         DynamicActionButton(mapState: .constant(.noInput))
     }
 }
