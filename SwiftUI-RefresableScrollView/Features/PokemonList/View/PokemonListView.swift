//
//  PokemonListView.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import SwiftUI

struct PokemonListView: View {
    // MARK: - Properties
    @StateObject private var vm = PokemonListVM()
    @StateObject private var orientationVm = DeviceOrientationVM()
    @StateObject private var refreshControl = RefreshableScrollViewModel()

    private let coordinateSpaceName = UUID()
    @State private var contentPosition: CGPoint = .zero
    @State private var isHideNavBar = true

    // MARK: - Layout
    private let sidePadding: CGFloat = isPhone ? 12 : 20

    private var coverGridColumns: [GridItem] {
        let gridItem = [GridItem(.flexible(), spacing: isPhone ? 10 : 14)]
        if isPhone {
            if orientationVm.orientation.isPortrait {
                return gridItem.repeated(count: 3)
            } else {
                return gridItem.repeated(count: 5)
            }
        } else {
            return gridItem.repeated(count: 4)
        }
    }

    // MARK: - UI Body
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Pokemon List")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.all, edges: .bottom)
                .navigationBarHidden(isHideNavBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onViewDidLoad {
            vm.refreshControl = refreshControl
            vm.onViewDidLoad()
        }
        .onChange(of: contentPosition) { position in
            let offset = position.y
            guard offset > -100 else { return }
            if offset <= -50 && isHideNavBar {
                isHideNavBar = false
                print("isHideNavBar: \(isHideNavBar)")
            } else if offset > -50 && !isHideNavBar {
                isHideNavBar = true
                print("isHideNavBar: \(isHideNavBar)")
            }
        }
    }

    // MARK: - View Components
    @ViewBuilder
    private var content: some View {
        RefreshableScrollView(vm: refreshControl, onRefresh: vm.pullToRefresh) {
            VStack(spacing: 0) {
                Text("Pokemon List")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(0x16161A))
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    .opacity(isHideNavBar ? 1 : 0)
                    .animation(.linear(duration: 0.3), value: isHideNavBar)
                LazyVGrid(columns: coverGridColumns, spacing: isPhone ? 10 : 14) {
                    ForEach(vm.pokeList) { item in
                        NavigationLink(destination: PokemonDetailView(item.model)) {
                            PokemonCardView(cardData: item.model)
                        }
                        .onAppear {
                            if item.id == vm.pokeList[safe: vm.pokeList.count - 3]?.id {
                                vm.loadPokeList()
                            }
                        }
                    }
                }
                .padding(.horizontal, sidePadding)
                .padding(.bottom, 10)

                if vm.isLoadingPokeList
                    && vm.pokeList.count >= 0 {
                    ProgressView()
                        .frameHorizontalExpand(alignment: .center)
                        .frame(height: 80, alignment: .top)
                }
            }
            .positionIn(space: coordinateSpaceName, offset: $contentPosition)
        }
        .clipped()
        .coordinateSpace(name: coordinateSpaceName)
        .background(listBackground)
    }

    @ViewBuilder
    private var listBackground: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(0xAFBBFF).opacity(0.8), Color(0xB6AAFF).opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().foregroundColor(Color(0xB8FFE6).opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 5)
                .offset(x: 100, y: -200)
            Circle().foregroundColor(Color(0x5BA4FF).opacity(0.4))
                .frame(width: 200, height: 200)
                .blur(radius: 5)
                .offset(x: -50, y: -30)
            Circle().foregroundColor(Color(0xFFF9AA).opacity(0.4))
                .frame(width: 360, height: 360)
                .blur(radius: 5)
                .offset(x: 80, y: 300)
        }
        .ignoresSafeArea()
    }

//    @ViewBuilder
//    private var refreshImage: some View {
//        LottieRefreshControlView(vm: refreshControl, fileName: "lottie-loading-cat", height: 80)
//    }
}

//struct LottieRefreshControlView: View {
//    @ObservedObject var vm: RefreshableScrollViewModel
//    var lottieFileName: String
//    var refreshViewHeight: CGFloat
//
//    init(vm: RefreshableScrollViewModel, fileName: String, height: CGFloat) {
//        self.vm = vm
//        self.lottieFileName = fileName
//        self.refreshViewHeight = height
//    }
//
//    var body: some View {
//        HStack {
//            ResizableLottieView(filename: lottieFileName, isPlaying: vm.isRefreshing)
//                .scaleEffect(vm.progress + 0.01)
//                .rotationEffect(.init(degrees: 180 * vm.progress))
//                .frame(height: refreshViewHeight * vm.progress)
//        }
//    }
//
//    private var iconOpacity: CGFloat {
//        if vm.isRefreshing {
//            return 0
//        } else {
//            return vm.isRefreahable ? vm.progress : 0
//        }
//    }
//}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
