//
//  ViewExtension.swift
//  Flashzilla
//
//  Created by Esben Viskum on 26/05/2021.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
