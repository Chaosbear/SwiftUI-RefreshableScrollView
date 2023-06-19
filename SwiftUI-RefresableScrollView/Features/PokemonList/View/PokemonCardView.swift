//
//  PokemonCardView.swift
//  SwiftUI-RefresableScrollView
//
//  Created by Sukrit Chatmeeboon on 19/6/2566 BE.
//

import SwiftUI
import Kingfisher
import Lottie

struct PokemonCardView: View {
    // MARK: - Properties
    private var cardData: PokemonModel

    // MARK: - Init
    init(cardData: PokemonModel) {
        self.cardData = cardData
    }

    // MARK: - View Body
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            thumbnailImage
            Text(cardData.name)
                .font(Font.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .foregroundLinearGradient(
                    colors: [
                        .white.opacity(0.2),
                        .white.opacity(0.4),
                        .white.opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(height: 160, alignment: .top)
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight)))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 4, x: 4, y: 4)
    }

    // MARK: - View Components
    @ViewBuilder
    private var thumbnailImage: some View {
        Color.clear
            .frameExpand()
            .frame(height: 100)
            .overlay(alignment: .center) {
                KFAnimatedImage(URL(string: cardData.imageUrl))
                    .backgroundDecode()
                    .placeholder { Color.gray.opacity(0.5).cornerRadius(12) }
                    .fade(duration: 0.5)
                    .aspectRatio(contentMode: .fit)
            }
            .clipped()
    }
}

struct PokemonCardView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCardView(cardData: PokemonModel(
            name: "Pokèmon",
            url: "",
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png"
        ))
        .frame(width: 160, height: 200)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VStack(spacing: 0) {
            Color.accentColor
            Color.green
        }.ignoresSafeArea())
    }
}
