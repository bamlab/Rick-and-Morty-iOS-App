//
//  EpisodesViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import UIKit
import Combine
import Resolver
import SwiftUI

struct EpisodesView: View {
    @InjectedObject var episodesViewModel: EpisodesViewModel
    @State var searchQuery: String = ""
    
    var filteredEpisodes: [Episode] {
        if searchQuery.isEmpty { return episodesViewModel.episodesSubject }
        else { return episodesViewModel.episodesSubject.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) } }
    }

    init() {
        UINavigationBar.appearance().tintColor = .rickBlue

    }

    var body: some View {
        NavigationView {
            if episodesViewModel.isFirstLoadingPageSubject {
                ProgressView().task {
                    await episodesViewModel.getEpisodes()
                }
            } else {
                List {
                    if episodesViewModel.episodesSubject.isEmpty && !episodesViewModel.canLoadMorePages {
                        Text("No episode found")
                    } else {
                        ForEach(filteredEpisodes, id: \.uuid) { episode in
                            Text(episode.name).foregroundColor(Color(UIColor.rickBlue))
                        }
                    }
                    
                    if episodesViewModel.canLoadMorePages && searchQuery.isEmpty {
                        Text("Loading more...")
                            .task { await episodesViewModel.getEpisodes() }
                    }
                }
                .searchable(text: $searchQuery)
                .navigationTitle("Episodes")
            }
        }
    }
}

struct Episodes_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView()
    }
}
