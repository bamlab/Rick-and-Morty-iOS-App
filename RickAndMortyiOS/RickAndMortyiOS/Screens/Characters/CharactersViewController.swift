//
//  CharactersViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import SwiftUI
import Combine
import Resolver
import Hero

struct CharactersView: View, CharacterFilterDelegate {
    @InjectedObject var charactersViewModel: CharactersViewModel
    @State var isFilterShow: Bool = false
    @State var searchQuery: String = ""
    @State private var selection: String? = nil

    var searchCharacters: [RickAndMortyCharacter] {
        if searchQuery.isEmpty {
            return charactersViewModel.charactersSubject
        } else {
            return charactersViewModel.charactersSubject.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationView {
            if charactersViewModel.isFirstLoadingPageSubject {
                ProgressView().task {
                    await charactersViewModel.getCharacters()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        if charactersViewModel.charactersSubject.isEmpty && !charactersViewModel.canLoadMorePages {
                            Text("No character found")
                        } else {
                            ForEach(searchCharacters, id: \.uuid) { character in
                                NavigationLink(
                                    destination: CharacterDetailView(character: character),
                                    tag: character.uuid.uuidString,
                                    selection: $selection
                                ) {
                                    CharacterCollectionSwiftUIViewCell(character: character)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            selection = character.uuid.uuidString
                                        }
                                }
                            }
                        }

                        if charactersViewModel.canLoadMorePages && !charactersViewModel.currentSearchQuery.isEmpty {
                            Text("Loading more...")
                                .task { await charactersViewModel.getCharacters() }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                }
                .searchable(text: $searchQuery)
                .navigationTitle("Characters")
                .toolbar {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .foregroundColor(Color(UIColor.rickBlue))
                        .onTapGesture {
                            isFilterShow.toggle()
                        }
                }
            }
        }
        .sheet(isPresented: $isFilterShow) {
            CharacterFilterView(
                filterDelegate: self,
                currentStatus: charactersViewModel.currentStatus,
                currentGender: charactersViewModel.currentGender
            )
        }
    }

    func didFilterTapped(selectedStatus: String?, selectedGender: String?) {
        charactersViewModel.currentStatus = selectedStatus ?? ""
        charactersViewModel.currentGender = selectedGender ?? ""
        charactersViewModel.isFirstLoadingPageSubject = true
        charactersViewModel.canLoadMorePages = true
        charactersViewModel.currentPage = 1
        Task {
            await charactersViewModel.getCharacters()
        }
        self.isFilterShow.toggle()
    }
}
