//
//  UIApplicationExtension.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import Foundation
import UIKit

extension UIApplication {
    class func interfaceOrientation() -> UIInterfaceOrientation? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .interfaceOrientation
    }
}
