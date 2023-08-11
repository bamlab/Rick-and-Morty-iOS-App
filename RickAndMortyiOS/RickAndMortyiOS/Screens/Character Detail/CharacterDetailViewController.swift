//
//  CharacterDetailViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 17.01.2021.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RickAndMortyCharacter
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: character.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "xmark").foregroundColor(Color.red)
                @unknown default:
                    EmptyView()
                }
            }.padding(.bottom, 8)

            Text("Name: \(character.name)")
                .font(.title)
                .foregroundColor(Color(uiColor: .rickBlue))
                .padding(.horizontal, 8)

            Text("Gender: \(character.gender)")
                .font(.title2)
                .foregroundColor(Color(uiColor: .rickGreen))
                .padding(.horizontal, 8)

            Text("Species: \(character.species)")
                .font(.title2)
                .foregroundColor(Color(uiColor: .rickGreen))
                .padding(.horizontal, 8)

            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}
