//
//  StoriesRepository.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import Foundation

enum FetchStoriesError: Error {
    case unimplemented
    case unknown
}

protocol IStoriesRepository {
    func fetchStories(completion: (Result<StoriesLinkedList, FetchStoriesError>) ->())
}

final class StoriesRepository: IStoriesRepository {
    
    func fetchStories(completion: (Result<StoriesLinkedList, FetchStoriesError>) -> ()) {
        completion(.failure(.unimplemented))
    }
    
}

struct StoriesRepositoryMock: IStoriesRepository {
    
    private let kStoriesFileName = "ActiveStories"
    
    func fetchStories(completion: (Result<StoriesLinkedList, FetchStoriesError>) -> ()) {
        guard let mockUrl = Bundle.main.url(forResource: kStoriesFileName, withExtension: "json") else {
            completion(.failure(.unknown))
            return
        }
        do {
            let data = try Data(contentsOf: mockUrl)
            let stories = try JSONDecoder().decode([ImageStoriesTO].self, from: data)
            let list = StoriesLinkedListFactory.createLinkedList(from: stories)
            completion(.success(list))
        } catch {
            completion(.failure(.unknown))
        }
        
    }
}
