//
//  TabView.swift
//  StepUp
//
//  Created by Hugo Blas on 21/02/2025.
//

import SwiftUI

struct AppMainView: View {

    @State var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            HomeScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            HomeScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
        }
    }
}

#Preview {
    AppMainView()
}

