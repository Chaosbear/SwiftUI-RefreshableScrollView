//
//  ApiPokemon.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import Foundation
import Alamofire

protocol PokemonDataSourceProtocol {
    func getPokeList(page: Int, limit: Int) -> DataRequest
    func getPokeDetail(name: String) -> DataRequest
}

extension ApiDataSource: PokemonDataSourceProtocol {
    func getPokeList(page: Int, limit: Int) -> DataRequest {
        return manager.apiRequest(.get, apiVersion: .v2_0, path: "/pokemon", parameters: [
            "offset": ((page - 1) * limit),
            "limit": limit
        ])
    }

    func getPokeDetail(name: String) -> DataRequest {
        return manager.apiRequest(.get, apiVersion: .v2_0, path: "/pokemon/\(name)")
    }
}

