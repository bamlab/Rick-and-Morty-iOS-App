//
//  LocationsViewModel.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 21.11.2020.
//

import Foundation
import Combine
import Resolver

class LocationsViewModel: ObservableObject {
    private var isLoadingPage = false

    @Published var locationsSubject: [Location] = []
    @Published var isFirstLoadingPageSubject = true

    var currentSearchQuery = ""
    var currentPage = 1
    var canLoadMorePages = true

    @LazyInjected private var networkService: NetworkService
    
    func getLocations() async {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        let request = LocationsRequest(name: currentSearchQuery, page: currentPage)
        do {
            let locationResponseModel = try await networkService.fetch(request)
            isLoadingPage = false
            locationsSubject.append(contentsOf: locationResponseModel.results)
            if locationResponseModel.pageInfo.pageCount == currentPage {
                canLoadMorePages = false
                return
            }
            currentPage += 1
            isFirstLoadingPageSubject = false
        } catch {
            #warning("TODO: Handle error")
            print(error.localizedDescription)
        }
    }
}
