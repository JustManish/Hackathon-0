//
//  ActionButton.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 30/10/22.
//

import SwiftUI

struct SystemImageActionButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                action()
            }
        } label: {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
    }
}
