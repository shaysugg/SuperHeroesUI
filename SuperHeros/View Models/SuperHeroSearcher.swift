//
//  SuperHeroSearcher.swift
//  SuperHeros
//
//  Created by Sha Yan on 10/4/20.
//

import Foundation
import Combine


class SuperHeroSearcher: ObservableObject {
    @Published private(set) var results = [SuperHero]() 
    @Published private(set) var error: Error?
    @Published private(set) var isFetching = false
    
    private var resultsSubscriber: AnyCancellable?
    private var errorSubscriber: AnyCancellable?
    
    private var searchQuery = PassthroughSubject<String, Never>()
    private var searchQuerySubscribers: [AnyCancellable] = []
    private var searchResultSubscriber: AnyCancellable?
    
    
    private var session: URLSession
    private var decoder: JSONDecoder
    
    
    init() {
        session = URLSession.shared
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        setupSearchQueryPipline()
        setupIsFetchingSubscribers()
        
    }
    
    private func setupIsFetchingSubscribers() {
        resultsSubscriber = $results.sink { [weak self] _ in
            self?.isFetching = false
        }
        
        errorSubscriber = $error.sink { [weak self] _ in
            self?.isFetching = false
        }
        
        searchQuerySubscribers.append(
            searchQuery
                .filter{!$0.isEmpty}
                .sink { [weak self] (_) in
                    self?.isFetching = true
                }
        )
    }
    
    
    
    private func setupSearchQueryPipline() {
        searchQuerySubscribers.append(contentsOf: [
            searchQuery
                .filter { !$0.isEmpty }
                .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
                
                .sink { [weak self] (string) in
                    print("👉 Search For: ", string)
                    self?.fethResultsFromSearchApi(withQuery: string)
                }
            ,
            
            searchQuery.filter {$0.isEmpty}
                .map{_ in []}
                .assign(to: \.results, on: self)
        ])
        
    }
    
    
    
    private func fethResultsFromSearchApi(withQuery name: String) {
        
        struct SearchResult: Decodable {
            let results: [SuperHero]?
            let error: String?
        }
        
        guard let url = URL(apiURLWithSubPath: "/search/\(name)") else {
            error = SearchError.unvalidURL
            return
        }
       
        searchResultSubscriber =
            session.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap{
                guard let httpResponse = $0.response as? HTTPURLResponse
                else { throw SearchError.unvalidResponse }
                guard (200...300).contains(httpResponse.statusCode)
                else { throw SearchError.networkError(httpResponse.statusCode) }
                
                return $0.data
            }
            .decode(type: SearchResult.self, decoder: decoder)
            .tryMap{
                guard let results = $0.results
                else { throw SearchError.notFound }
                
                return results
            }
            .catch { [weak self] (error) -> Just<[SuperHero]> in
                self?.error = error
                print("❌ Network Error:", error.localizedDescription)
                return Just([])
            }
            .assign(to: \.results, on: self)
            
    }
    
    
    public func search(bySuperHeroName name: String) {
        searchQuery.send(name)
    }
    
}


enum SearchError: Error {
    case unvalidURL
    case notFound
    case networkError(Int)
    case unvalidResponse
}
