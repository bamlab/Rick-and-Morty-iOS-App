//
//  LocationsViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import SwiftUI
import Combine
import Resolver

struct LocationsView: View {
    @InjectedObject var locationsViewModel: LocationsViewModel
    @State var searchQuery: String = ""
    
    var filteredLocations: [Location] {
        if searchQuery.isEmpty { return locationsViewModel.locationsSubject }
        else { return locationsViewModel.locationsSubject.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) } }
    }

    var body: some View {
        NavigationView {
            if locationsViewModel.isFirstLoadingPageSubject {
                ProgressView().task {
                    await locationsViewModel.getLocations()
                }
            } else {
                List {
                    if locationsViewModel.locationsSubject.isEmpty && !locationsViewModel.canLoadMorePages {
                        Text("No location found")
                    } else {
                        ForEach(filteredLocations, id: \.uuid) { location in
                            Text(location.name).foregroundColor(Color(UIColor.rickBlue))
                        }
                    }
                    
                    if locationsViewModel.canLoadMorePages && searchQuery.isEmpty {
                        Text("Loading more...")
                            .task { await locationsViewModel.getLocations() }
                    }
                }
                .searchable(text: $searchQuery, prompt: "Search a Location")
                .navigationTitle("Locations")
            }
        }
    }
}
