//
//  ArchiveView.swift
//  MyApp
//
//  Created by Daniel on 22/6/26.
//

import Foundation
import SwiftUI

struct ArchiveView: View {
    @AppStorage("backgroundColor") var backgroundColor: String = ""
    var body: some View {
            ScrollView(.vertical){
                CardStackView()
            }
            .frame(width: .infinity, height: .infinity)
    }
}

#Preview {
    ContentView()
}
