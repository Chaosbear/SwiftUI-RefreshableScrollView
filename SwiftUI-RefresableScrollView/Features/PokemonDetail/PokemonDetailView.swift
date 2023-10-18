//
//  PokemonDetailView.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 15/10/2566 BE.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    // MARK: - Properties
    private let pokemon: PokemonModel

    // MARK: - Layout
    private let sidePadding: CGFloat = isPhone ? 12 : 20

    // MARK: - Life Cycle
    init(_ pokemon: PokemonModel) {
        self.pokemon = pokemon
    }

    // MARK: - UI Body
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Color.clear
                .frameExpand()
                .frame(height: 160)
                .overlay(alignment: .center) {
                    KFAnimatedImage(URL(string: pokemon.imageUrl))
                        .backgroundDecode()
                        .placeholder {
                            Image("pikachu-placeholder")
                                .resizable()
                        }
                        .fade(duration: 0.5)
                        .aspectRatio(contentMode: .fit)
                }
                .clipped()
            Text(pokemon.name)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(0x16161A))
        }
        .padding(.horizontal, sidePadding)
        .frameExpand(alignment: .center)
        .background(pageBackground)
    }

    // MARK: - View Components
    @ViewBuilder
    private var pageBackground: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(0xAFBBFF).opacity(0.8), Color(0xB6AAFF).opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().foregroundColor(Color(0xB8FFE6).opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 20)
                .offset(x: 100, y: -200)
            Circle().foregroundColor(Color(0x5BA4FF).opacity(0.4))
                .frame(width: 200, height: 200)
                .blur(radius: 20)
                .offset(x: -50, y: -30)
            Circle().foregroundColor(Color(0xFFF9AA).opacity(0.4))
                .frame(width: 360, height: 360)
                .blur(radius: 20)
                .offset(x: 80, y: 300)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PokemonDetailView(.default())
}
