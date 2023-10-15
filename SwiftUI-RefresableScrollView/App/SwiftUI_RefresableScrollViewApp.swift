//
//  SwiftUI_RefresableScrollViewApp.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import SwiftUI

@main
struct SwiftUI_RefresableScrollViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onViewDidLoad {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor(.init(0xB4D5FA))
                    appearance.backgroundEffect = .init(style: .systemUltraThinMaterial)
                    appearance.shadowColor = nil

                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
        }
    }
}
