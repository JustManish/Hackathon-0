//
//  ContentView.swift
//  Targaryen Dragons
//
//  Created by Nasir Ahmed Momin on 27/10/22.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
