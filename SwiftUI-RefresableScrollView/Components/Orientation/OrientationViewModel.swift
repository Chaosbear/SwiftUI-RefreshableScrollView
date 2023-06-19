//
//  OrientationViewModel.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import UIKit
import Combine

class DeviceOrientationVM: ObservableObject {
    // MARK: - Properties
    enum Orientation {
        case portrait
        case portraitUpsideDown
        case landscapeLeft
        case landscapeRight

        var isLandscape: Bool {
            return self == .landscapeLeft || self == .landscapeRight
        }

        var isPortrait: Bool {
            return self == .portrait || self == .portraitUpsideDown
        }
    }
    @Published private(set) var orientation: Orientation = mapOrientation(UIApplication.interfaceOrientation() ?? .portrait)

    private var disposeBag: Set<AnyCancellable> = []

    // MARK: - Life Cycle
    init() {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification, object: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noti in
                guard let self = self,
                      let device = noti.object as? UIDevice,
                      device.orientation != .faceUp,
                      device.orientation != .faceDown,
                      device.orientation != .portraitUpsideDown
                else { return }
                let interfaceOrientation = UIApplication.interfaceOrientation() ?? .portrait
                self.orientation = DeviceOrientationVM.mapOrientation(interfaceOrientation)
            }
            .store(in: &disposeBag)
    }

    static func mapOrientation(_ interfaceOrientation: UIInterfaceOrientation) -> Orientation {
        switch interfaceOrientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return interfaceOrientation.isLandscape ? .landscapeRight : .portrait
        }
    }
}
