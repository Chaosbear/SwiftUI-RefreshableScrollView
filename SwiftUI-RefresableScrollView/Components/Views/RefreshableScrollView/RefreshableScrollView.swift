//
//  RefreshableScrollView.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import SwiftUI
import Combine

struct RefreshableScrollView<Content: View>: View {
    var content: Content
    var refreshView: AnyView
    var showIndicator: Bool
    private var refreshViewHeight: CGFloat
    private var heightTheshold: CGFloat

    @ObservedObject var vm: RefreshableScrollViewModel
    @State private var isPreventGesture = false
    @State private var isDisableGesture = false

    var onRefresh: () -> Void

    init(
        vm: RefreshableScrollViewModel,
        showIndicator: Bool = true,
        refreshViewHeight: CGFloat = 80,
        heightTheshold: CGFloat = 60,
        refreshView: AnyView? = nil,
        @ViewBuilder content: () -> Content,
        onRefresh: @escaping () -> Void
    ) {
        self.vm = vm
        self.showIndicator = showIndicator
        self.refreshViewHeight = refreshViewHeight
        self.heightTheshold = heightTheshold
        self.refreshView = refreshView ?? AnyView(DefaultRefreshControlView(vm: vm))
        self.content = content()
        self.onRefresh = onRefresh
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: showIndicator) {
            VStack(spacing: 0) {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .named("SCROLL")).minY

                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: minY)
                }
                .frame(height: 0)
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    // prevent unneeded offset processing to improve performance
                    guard value < heightTheshold + 10 && value > -1 else { return }
                    vm.contentOffset = value

                    if !vm.isRefreshing {
                        var scrollProgress = value / heightTheshold
                        scrollProgress = (scrollProgress < 0 ? 0 : scrollProgress)
                        scrollProgress = (scrollProgress > 1 ? 1 : scrollProgress)
                        vm.scrollOffset = value
                        vm.progress = (scrollProgress * 100).rounded() / 100
                    }

                    if value >= heightTheshold {
                        vm.startRefresh()
                    }
                }
                Color.clear
                    .frame(height: refreshViewHeight * vm.progress)
                content
            }
        }
        .background {
            VStack(spacing: 0) {
                refreshView
                    .frame(height: refreshViewHeight * vm.progress)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .accessibilityHidden(true)
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .center) {
            if isPreventGesture {
                Rectangle().fill(Color.white.opacity(0))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                EmptyView()
            }
        }
        .disabled(isDisableGesture)
        .onChange(of: vm.isRefreshing) { newValue in
            if newValue {
                onRefresh()
            } else {
                isPreventGesture = true
                isDisableGesture = true
                // use DispatchQueue.main.async to ensure that scrollview is redrawed and disabled
                // to cancel current gesture
                DispatchQueue.main.async {
                    isDisableGesture = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isPreventGesture = false
                    }
                    withAnimation(.linear(duration: 0.3)) {
                        vm.progress = 0
                    }
                    vm.scrollOffset = 0
                    vm.contentOffset = 0
                }
            }
        }
    }
}

struct DefaultRefreshControlView: View {
    @ObservedObject var vm: RefreshableScrollViewModel

    var body: some View {
        HStack {
            if vm.isRefreshing {
                ProgressView()
                    .scaleEffect(1.5)
                    .opacity(vm.isRefreshing ? 1 : 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 180 * vm.progress * vm.progress))
                    .animation(.easeInOut(duration: 0.1), value: vm.isRefreshing)
                    .opacity(iconOpacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }

    private var iconOpacity: CGFloat {
        if vm.isRefreshing {
            return 0
        } else {
            return vm.isRefreahable ? vm.progress : 0
        }
    }
}

class RefreshableScrollViewModel: ObservableObject {
    // MARK: - Properties
    @Published var progress: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var scrollOffset: CGFloat = 0
    @Published private(set) var isRefreshing: Bool = false
    private(set) var isRefreahable: Bool = true

    private var disposeBag = Set<AnyCancellable>()

    // MARK: - Life Cycle
    init() {
        $progress
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                if $0 == 0 && !self.isRefreshing {
                    self.isRefreahable = true
                }
            }
            .store(in: &disposeBag)
    }

    // MARK: - Actions
    func startRefresh() {
        if !isRefreshing && isRefreahable {
            isRefreshing = true
            isRefreahable = false
        }
    }

    func endRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.isRefreshing = false
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
