//
//  LookAroundView.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI
import MapKit

struct LookAroundView: UIViewRepresentable {
    var lookAroundControler = MKLookAroundViewController()
    var size = CGSize(width: 150, height: 100)
    let lookAroundScene: MKLookAroundScene?
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.addSubview(lookAroundControler.view)
        lookAroundControler.scene = lookAroundScene
        NSLayoutConstraint.activate([
            lookAroundControler.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lookAroundControler.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lookAroundControler.view.topAnchor.constraint(equalTo: view.topAnchor),
            lookAroundControler.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        //lookAroundControler.didMove(toParent: self)
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
    }
}
