//
//  EpisodesViewModel.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 22.11.2020.
//

import Foundation
import Combine
import Resolver

class EpisodesViewModel: ObservableObject {
    private var isLoadingPage = false
    
    @Published var isFirstLoadingPageSubject = true
    @Published var episodesSubject: [Episode] = []
    
    var currentSearchQuery = ""
    var currentPage = 1
    var canLoadMorePages = true

    @LazyInjected private var networkService: NetworkService
    
    func getEpisodes() async {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        let request = EpisodesRequest(name: currentSearchQuery, page: currentPage)
        do {
            let episodeResponseModel = try await networkService.fetch(request)
            isLoadingPage = false
            episodesSubject.append(contentsOf: episodeResponseModel.results)
            if episodeResponseModel.pageInfo.pageCount == currentPage {
                canLoadMorePages = false
                return
            }
            currentPage += 1
            isFirstLoadingPageSubject = false
        } catch {
            #warning("TODO: Handle error")
            if let apiError = error as? APIError {
                print(apiError.errorMessage)
            }
            print(error.localizedDescription)
        }
    }
}
