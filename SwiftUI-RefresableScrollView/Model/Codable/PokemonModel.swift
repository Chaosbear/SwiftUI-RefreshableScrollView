//
//  PokemonModel.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 18/6/2566 BE.
//

import Foundation

struct PokemonListModel {
    var count: Int = 0
    var next: String?
    var previous: String?
    var results: [PokemonModel] = []

    static let `default` = Self()
}

extension PokemonListModel: Codable {

    enum CodingKeys: String, CodingKey {
        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.count = try map.decodeIfPresent(Int.self, forKey: .count) ?? 0
            self.next = try map.decodeIfPresent(String?.self, forKey: .next) ?? nil
            self.previous = try map.decodeIfPresent(String?.self, forKey: .previous) ?? nil
            self.results = try map.decodeIfPresent([PokemonModel].self, forKey: .results) ?? []
        } catch {
            self = Self()
        }
    }
}

struct PokemonModel {
    var name: String = "n/a"
    var url: String = "n/a"
    var imageUrl: String = "n/a"

    static func `default`() -> Self { Self() }
}

extension PokemonModel: Codable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
        case imageUrl = "imageUrl"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        do {
            self.name = try map.decodeIfPresent(String.self, forKey: .name) ?? "n/a"
            self.url = try map.decodeIfPresent(String.self, forKey: .url) ?? "n/a"
            self.imageUrl = try map.decodeIfPresent(String.self, forKey: .imageUrl) ?? "n/a"
        } catch {
            self = Self()
        }
    }
}

struct PokemonDetailModel: Codable {
    var name: String = "n/a"
    var url: String = "n/a"
    var imageUrl: String = "n/a"

    static let `default` = Self()
}
