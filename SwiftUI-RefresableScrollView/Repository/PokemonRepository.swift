//
//  PokemonRepository.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import Foundation
import Alamofire

protocol PokemonRepositoryProtocol {
    func getPokeList(
        page: Int,
        limit: Int,
        completion: @escaping (PokemonListModel?) -> Void
    )
    func getPokeDetail(
        name: String,
        completion: @escaping (PokemonDetailModel?) -> Void
    )
}

struct PokemonRepository: PokemonRepositoryProtocol {

    private var dataSource: PokemonDataSourceProtocol

    init(dataSource: PokemonDataSourceProtocol = ApiDataSource()) {
        self.dataSource = dataSource
    }

    func getPokeList(
        page: Int,
        limit: Int,
        completion: @escaping (PokemonListModel?) -> Void
    ) {
        dataSource.getPokeList(page: page, limit: limit)
            .responseDecodable(of: PokemonListModel.self) { dataResponse in
                if dataResponse.response != nil {
                    switch dataResponse.result {
                    case .success(let value):
                        let pokeList = value.results
                        let mappedList = pokeList.map { pokemon in
                            return PokemonModel(
                                name: pokemon.name,
                                url: pokemon.url,
                                imageUrl: getPokemonImageUrl(url: pokemon.url)
                            )
                        }
                        var mappedPokeList = value
                        mappedPokeList.results = mappedList
                        completion(mappedPokeList)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
    }

    func getPokeDetail(
        name: String,
        completion: @escaping (PokemonDetailModel?) -> Void
    ) {
        dataSource.getPokeDetail(name: name)
            .responseDecodable(of: PokemonDetailModel.self) { dataResponse in
                if let response = dataResponse.response {
                    switch dataResponse.result {
                    case .success(let value):
                        completion(value)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
    }

    func getPokemonImageUrl(url: String) -> String {
        let pokemonId = url.components(separatedBy: "/").last(where: { Int($0) != nil })
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(pokemonId ?? "1").png"
    }
}
