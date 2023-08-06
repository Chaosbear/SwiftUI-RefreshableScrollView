//
//  LottieView.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import Foundation
import SwiftUI
import Lottie

struct ResizableLottieView: UIViewRepresentable {
    var filename: String
    var isPlaying: Bool

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        addLottieView(to: view)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.subviews.forEach { view in
            if view.tag == 1009, let lottieView = view as? LottieAnimationView {
                if isPlaying {
                    lottieView.play()
                } else {
                    lottieView.pause()
                }
            }
        }
    }

    func addLottieView(to view: UIView) {
        let lottieView = LottieAnimationView(name: filename, bundle: .main)
        lottieView.loopMode = .loop
        lottieView.backgroundColor = .clear
        // For finding it in subView and use for animating
        lottieView.tag = 1009
        lottieView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: view.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]

        view.addSubview(lottieView)
        view.addConstraints(constraints)
    }
}
