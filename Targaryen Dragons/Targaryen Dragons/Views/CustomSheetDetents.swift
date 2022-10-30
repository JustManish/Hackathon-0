//
//  CustomSheetDetents.swift
//  Targaryen Dragons
//
//  Created by Shaktiprasad Mohanty on 28/10/22.
//

import SwiftUI

struct TinyDetent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        if context.dynamicTypeSize.isAccessibilitySize {
            return 140
        } else {
            return 60
        }
    }
}
