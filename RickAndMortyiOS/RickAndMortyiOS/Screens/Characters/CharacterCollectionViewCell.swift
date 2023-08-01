//
//  CharacterCollectionViewCell.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 6.12.2020.
//

import SwiftUI
import SDWebImage
import Hero
import TinyConstraints

final class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "CharacterCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }

    func set(with character: RickAndMortyCharacter) {
        contentView.addSubview(
            UIHostingController(
                rootView: CharacterCollectionSwiftUIViewCell(
                    character: RickAndMortyCharacter(
                        id: character.id,
                        name: character.name,
                        status: character.status,
                        species: character.species,
                        gender: character.gender,
                        imageUrl: character.imageUrl,
                        created: character.created
                    )
                )
            ).view
        )
    }
}

struct CharacterCollectionSwiftUIViewCell: View {
    let character: RickAndMortyCharacter
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            AsyncImage(url: URL(string: character.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                case .failure:
                    Image(systemName: "xmark").foregroundColor(Color.red)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            .padding(.horizontal, 4)
            .padding(.vertical, 8)

            Text(character.name)
                .lineLimit(1)
                .font(.headline)
                .minimumScaleFactor(0.1)
                .scaledToFill()
                .foregroundColor(.white)

            HStack(spacing: 2) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(Color(character.statusColor))

                Text("\(character.status.rawValue) - \(character.species)")
                    .lineLimit(1)
                    .font(.callout)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            .padding(.vertical, 2)
        }
        .padding(.horizontal, 4)
        .background(Color(UIColor.rickBlue))
        .cornerRadius(10)
        .scaledToFit()
        .frame(width: 100, height: 200)
        .position(x: 56, y: 80)
    }
}
