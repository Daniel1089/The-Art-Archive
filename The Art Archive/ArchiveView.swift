//
//  ArchiveView.swift
//  MyApp
//
//  Created by Daniel on 22/6/26.
//

import Foundation
import SwiftUI

struct ArchiveView: View {
    var body: some View {
            ScrollView(.vertical){
                CardStackView()
                    .safeAreaPadding(.top, 5)
                    .safeAreaBar(edge: .top){
                    }
            }
    }
}

#Preview {
    ContentView()
}
