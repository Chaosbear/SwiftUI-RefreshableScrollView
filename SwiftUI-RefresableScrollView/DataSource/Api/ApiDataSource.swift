//
//  ApiDataSource.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import Foundation

class ApiDataSource {

    // MARK: - Properties

    static let shared = ApiDataSource()
    public let manager = ApiManager.shared

    // MARK: - Config

    open func defaultParameters() -> [String: Any] {
        return [String: Any]()
    }
}
