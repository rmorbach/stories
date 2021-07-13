//
//  StoriesLinkedListFactory.swift
//  Stories
//
//  Created by Rodrigo Morbach on 12/07/21.
//

import Foundation

protocol IStoriesLinkedListFactory {
    static func createLinkedList(from stories: [StoriesTO]) -> StoriesLinkedList
}

struct StoriesLinkedListFactory: IStoriesLinkedListFactory {
    static func createLinkedList(from stories: [StoriesTO]) -> StoriesLinkedList {
        let list = StoriesLinkedList()
        stories.forEach {
            list.append($0)
        }
        return list
    }
}
