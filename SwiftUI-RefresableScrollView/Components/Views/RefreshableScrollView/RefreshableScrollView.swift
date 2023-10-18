//
//  RefreshableScrollView.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import SwiftUI
import Combine

struct RefreshableScrollView<Content: View>: View {
    private var content: Content
    private var showIndicator: Bool
    private var axis: Axis.Set
    private var onRefresh: () -> Void

    @ObservedObject var vm: RefreshableScrollViewModel

    init(
        vm: RefreshableScrollViewModel,
        axis: Axis.Set = .vertical,
        showIndicator: Bool = true,
        onRefresh: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.vm = vm
        self.axis = axis
        self.showIndicator = showIndicator
        self.onRefresh = onRefresh
        self.content = content()
    }

    var body: some View {
        ScrollView(axis, showsIndicators: showIndicator) {
            content
        }
        .refreshable {
            await vm.startRefresh(onRefresh)
        }
    }
}

class RefreshableScrollViewModel: ObservableObject {
    // MARK: - Properties
    private(set) var isRefreshing = false

    // limit waiting time to ensure that continuation must be called resume
    private let refreshDurationLimit: Double
    private var refreshContinuation: CheckedContinuation<Void, Never>?

    // MARK: - Life Cycle
    init(refreshDurationLimit: Double = 80) {
        self.refreshDurationLimit = refreshDurationLimit
    }

    deinit {
        // prevent continuation leak when user dismiss page while refreshing
        if refreshContinuation != nil {
            refreshContinuation?.resume()
            refreshContinuation = nil
        }
    }

    // MARK: - Actions
    func startRefresh(_ onRefresh: @escaping () -> Void) async {
        guard refreshContinuation == nil else { return }

        isRefreshing = true
        await withCheckedContinuation { [weak self] (continution: CheckedContinuation<Void, Never>) in
            guard let self = self else {
                continution.resume()
                return
            }
            self.refreshContinuation = continution
            // call onRefresh after asiign continution to refreshContinuation to prevent the case
            // that endRefresh is called before continution is assigned
            DispatchQueue.main.async {
                onRefresh()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + refreshDurationLimit) { [weak self] in
                self?.endRefresh()
            }
        }
    }

    func endRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self, self.refreshContinuation != nil else { return }

            self.isRefreshing = false
            self.refreshContinuation?.resume()
            self.refreshContinuation = nil
        }
    }
}
