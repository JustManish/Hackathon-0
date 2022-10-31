//
 //  LocationSearchView.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import SwiftUI

 struct LocationSearchListView: View {
     @State private var startLocationText = ""
     @Binding var mapState: MapViewState
     @EnvironmentObject var viewModel: LocationSearchViewModel

     var body: some View {
         VStack {
             HStack {
                 VStack {
                     Circle()
                         .fill(Color(.systemGray3))
                         .frame(width: 6, height: 6)

                     Rectangle()
                         .fill(Color(.systemGray3))
                         .frame(width: 1, height: 24)

                     Rectangle()
                         .fill(Color.gray.opacity(0.5))
                         .frame(width: 6, height: 6)
                 }

                 VStack {
                     TextField("Current location", text: $startLocationText)
                         .frame(height: 32)
                         .background(Color(.systemGroupedBackground))
                         .padding(.trailing)
                         .disabled(true)

                     TextField("Where to?", text: $viewModel.queryFragment)
                         .frame(height: 32)
                         .foregroundColor(.black)
                         .background(Color(.white))
                         .padding(.trailing)
                 }
             }
             .padding(.horizontal)
             .padding(.top, 64)

             Divider()
                 .padding(.vertical)

             // list view
             ScrollView {
                 LazyVStack(alignment: .leading) {
                     ForEach(viewModel.results, id: \.self) { result in
                         LocationSearchResultView(title: result.title, subtitle: result.subtitle)
                             .onTapGesture {
                                 withAnimation(.spring()) {
                                     viewModel.selectLocation(result)
                                     mapState = .locationSelected
                                 }
                             }
                     }
                 }
             }
         }
         .background(Color.gray.opacity(0.5))
         .background(.white)
     }
 }

 struct LocationSearchView_Previews: PreviewProvider {
     static var previews: some View {
         LocationSearchListView(mapState: .constant(.searchingForLocation))
     }
 }
