//
//  LookAroundView.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI
import MapKit

struct MapLookAroundView: UIViewRepresentable {
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    let lookAroundControler = MKLookAroundViewController()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 165, height: 100))
        prepareLookAroundView(view)
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        prepareLookAroundView(view)
    }
    
    func prepareLookAroundView(_ view: UIView) {
        let lookAroundControler = lookAroundControler
        lookAroundControler.view.removeFromSuperview()
        view.addSubview(lookAroundControler.view)
        lookAroundControler.scene = locationViewModel.lookAroundScene
        NSLayoutConstraint.activate([
            lookAroundControler.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lookAroundControler.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lookAroundControler.view.topAnchor.constraint(equalTo: view.topAnchor),
            lookAroundControler.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
