//
//  ViewExtension.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import SwiftUI

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }

    func frameHorizontalExpand(alignment: HorizontalAlignment? = .center) -> some View {
        frame(
            maxWidth: alignment.flatMap { _ in .infinity },
            alignment: Alignment(horizontal: alignment ?? .center, vertical: .center)
        )
    }

    func frameVerticalExpand(alignment: VerticalAlignment? = .center) -> some View {
        frame(
            maxHeight: alignment.flatMap { _ in .infinity },
            alignment: Alignment(horizontal: .center, vertical: alignment ?? .center)
        )
    }

    func frameExpand(alignment: Alignment? = .center) -> some View {
        frame(maxWidth: alignment.flatMap { _ in .infinity }, maxHeight: .infinity, alignment: alignment ?? .center)
    }
}

private struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {
    func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> some View {
        self.overlay {
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self

            )
        }
    }

    func positionIn(space: UUID, offset: Binding<CGPoint>) -> some View {
        PositionObservingView(
            coordinateSpace: .named(space),
            position: offset,
            content: { self }
        )
    }
}

extension Color {
    init(_ hex: UInt32, opacity:Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
