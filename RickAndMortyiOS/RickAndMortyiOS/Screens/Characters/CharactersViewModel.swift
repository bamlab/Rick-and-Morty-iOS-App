//
//  CharactersViewModel.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 6.12.2020.
//

import Foundation
import Combine
import Resolver

class CharactersViewModel: ObservableObject {
    
    private var isLoadingPage = false
    
    @Published var charactersSubject: [RickAndMortyCharacter] = []
    @Published var isFirstLoadingPageSubject = true
    var currentSearchQuery = ""
    var currentStatus = ""
    var currentGender = ""
    var currentPage = 1
    var canLoadMorePages = true
    
    @LazyInjected private var networkService: NetworkService
    
    func getCharacters() async {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        let request = CharactersRequest(name: currentSearchQuery, status: currentStatus, gender: currentGender, page: currentPage)
        do {
            let characterResponseModel = try await networkService.fetch(request)
            isLoadingPage = false
            isFirstLoadingPageSubject = false
            if currentPage == 1 {
                charactersSubject.removeAll()
            }
            charactersSubject.append(contentsOf: characterResponseModel.results)
            if characterResponseModel.pageInfo.pageCount == currentPage {
                canLoadMorePages = false
                return
            }
            currentPage += 1
        } catch {
            #warning("TODO: Handle error")
            if let apiError = error as? APIError {
                print(apiError.errorMessage)
            }
            print(error.localizedDescription)
        }
    }
}
