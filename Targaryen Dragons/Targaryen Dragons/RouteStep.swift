//
 //  RouteStep.swift
 //  Targaryen Dragons
 //
 //  Created by Manish Patidar on 28/10/22.
 //

 import Foundation
 import MapKit

 struct RouteStep: Identifiable {
     let id = UUID()
     let step: MKRoute.Step
 }
