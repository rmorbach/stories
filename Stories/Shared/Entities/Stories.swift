//
//  Stories.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import Foundation

struct User: Codable {
    let name: String
    let photoUrl: URL
}
struct Post: Codable {
    let datetime: TimeInterval
    let photoUrl: URL
    let message: String
}


protocol StoriesTO: Codable {
    var user: User { get }
    var posts: [Post] { get }
}

struct ImageStoriesTO: StoriesTO {
    let user: User
    let posts: [Post]
}

