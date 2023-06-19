//
//  PokemonListViewModel.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import Foundation

class PokemonListVM: ObservableObject {

    // MARK: - Properties
    @Published private(set) var pokeList: [PokemonModel] = []
    @Published private(set) var totalPokemon = 0

    private var pageStates: DefaultPaginationStates = .init()

    @Published private(set) var isLoadingPokeList = false
    @Published private(set) var isShowSkeleton = true

    weak var refreshControl: RefreshableScrollViewModel?

    private let repository: PokemonRepositoryProtocol

    // MARK: - Life Cycle
    init(repository: PokemonRepositoryProtocol = PokemonRepository()) {
        self.repository = repository
    }

    // MARK: - Action: ViewDidLoad
    func onViewDidLoad() {
        loadPokeList()
    }

    // MARK: - Action: Load Data
    func loadPokeList() {
        print("load poke list")
        guard pageStates.hasNext && !isLoadingPokeList else { return }
        getPokeList(page: pageStates.loadedPage + 1)
    }

    // MARK: - Action: Call API
    private func getPokeList(
        page: Int,
        limit: Int = 20
    ) {
        guard !isLoadingPokeList else { return }
        isLoadingPokeList = true

        repository.getPokeList(page: page, limit: limit) { [weak self] value in
            guard let self = self else { return }
            if page == 0 {
                self.pokeList.removeAll()
            }
            if let list = value {
                self.pokeList.append(contentsOf: list.results)
                self.pageStates.loadedPage = page + 1
                self.pageStates.hasNext = list.next != nil
            }
            self.isLoadingPokeList = false
            if let isRefreshing = self.refreshControl?.isRefreshing, isRefreshing {
                self.refreshControl?.endRefresh()
            }
        }
    }

    // MARK: - Action: Reset/Refresh Data
    func pullToRefresh() {
        pageStates = .init()
        loadPokeList()
    }
}
