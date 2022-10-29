//
//  LookAroundView.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI
import MapKit

struct LookAroundView: UIViewRepresentable {
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    
    func makeUIView(context: Context) -> UIView {
        let lookAroundControler = locationViewModel.lookAroundControler
        print(lookAroundControler)
        print("===")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 165, height: 100))
        setEmbbadedVC(view)

        //lookAroundControler.didMove(toParent: self)
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        setEmbbadedVC(view)
    }
    
    func setEmbbadedVC(_ view: UIView) {
        print(locationViewModel.lookAroundControler)
        print(locationViewModel.lookAroundScene)
        print("===")
        let lookAroundControler = locationViewModel.lookAroundControler
        lookAroundControler.view.removeFromSuperview()
        view.addSubview(lookAroundControler.view)
        locationViewModel.lookAroundControler.scene = locationViewModel.lookAroundScene
        NSLayoutConstraint.activate([
            lookAroundControler.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lookAroundControler.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lookAroundControler.view.topAnchor.constraint(equalTo: view.topAnchor),
            lookAroundControler.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
