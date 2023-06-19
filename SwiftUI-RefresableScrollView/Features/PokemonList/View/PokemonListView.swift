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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onViewDidLoad {
            vm.refreshControl = refreshControl
            vm.onViewDidLoad()
        }
    }

    // MARK: - View Components
    @ViewBuilder
    private var content: some View {
        RefreshableScrollView(vm: refreshControl, refreshView: AnyView(refreshImage)) {
            VStack(spacing: 0) {
                LazyVGrid(columns: coverGridColumns, spacing: isPhone ? 10 : 14) {
                    ForEach(vm.pokeList.indices, id: \.self) { index in
                        let pokemon = vm.pokeList[index]

                        NavigationLink(destination: VStack { Text("Pokemon Detail") }) {
                            PokemonCardView(cardData: pokemon)
                        }
                        .onAppear {
                            if index >= (vm.pokeList.count - 3) {
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
        } onRefresh: {
            vm.pullToRefresh()
        }
        .clipped()
        .background(listBackground)
    }

    @ViewBuilder
    private var listBackground: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(0xF1DEC9).opacity(0.5), Color(0x8D7B68).opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().foregroundColor(Color(0x8D7B68).opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 5)
                .offset(x: 100, y: -200)
            Circle().foregroundColor(Color(0xC8B6A6).opacity(0.4))
                .frame(width: 200, height: 200)
                .blur(radius: 5)
                .offset(x: -50, y: -50)
            Circle().foregroundColor(.yellow.opacity(0.3))
                .frame(width: 100, height: 100)
                .blur(radius: 5)
                .offset(x: 80, y: 200)
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var refreshImage: some View {
        LottieRefreshControlView(vm: refreshControl, fileName: "lottie-loading-cat", height: 80)
    }
}

struct LottieRefreshControlView: View {
    @ObservedObject var vm: RefreshableScrollViewModel
    var lottieFileName: String
    var refreshViewHeight: CGFloat

    init(vm: RefreshableScrollViewModel, fileName: String, height: CGFloat) {
        self.vm = vm
        self.lottieFileName = fileName
        self.refreshViewHeight = height
    }

    var body: some View {
        HStack {
            ResizableLottieView(filename: lottieFileName, isPlaying: vm.isRefreshing)
                .scaleEffect(vm.progress + 0.01)
                .rotationEffect(.init(degrees: 180 * vm.progress))
                .frame(height: refreshViewHeight * vm.progress)
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

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
