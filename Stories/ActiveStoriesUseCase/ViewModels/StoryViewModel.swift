//
//  StoryViewModel.swift
//  Stories
//
//  Created by Rodrigo Morbach on 19/07/21.
//

import Foundation

enum Direction {
    case backwards, forward
}

protocol StoryViewModelProtocol {
    var story: StoriesTO { get }
    var currentIndex: Int { get }
    var posts: [Post] { get }
    var userName: String { get }
    var userPhoto: URL { get }
    
    func post(at index: Int) -> Post?
    func dateTime(forPost post: Post) -> String
    func message(forPost post: Post) -> String
    func url(forPost post: Post) -> URL
    func navigate(to direction: Direction)
}


final class StoryViewModel: StoryViewModelProtocol {

    let story: StoriesTO
    private(set) var currentIndex: Int = -1
    
    init(withStory story: StoriesTO) {
        self.story = story
    }
    
    var posts: [Post] {
        return story.posts
    }
    
    var userName: String {
        return story.user.name
    }
    
    var userPhoto: URL {
        return story.user.photoUrl
    }
    
    func post(at index: Int) -> Post? {
        guard index < story.posts.count else {
            return nil
        }
        return story.posts[index]
    }
    
    func dateTime(forPost post: Post) -> String {
        return dateTimeFor(date: Date(timeIntervalSince1970: post.datetime / 1000))
    }
    
    private func dateTimeFor(date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        var message = "Há "
        if let day = components.day, day > 0 {
            message += "\(day) dias"
        } else if let hours = components.hour, hours > 0 {
            message += "\(hours) horas"
        } else if let minutes = components.minute, minutes > 0 {
            message += "\(minutes) minutos"
        } else {
            message = "Agora mesmo"
        }
        return message
    }
    
    func message(forPost post: Post) -> String {
        return post.message
    }
    
    func url(forPost post: Post) -> URL {
        return post.photoUrl
    }
    
    func navigate(to direction: Direction) {
        switch direction {
        case .forward:
            currentIndex += 1
        case .backwards:
            currentIndex -= 1
        }
        
        if currentIndex < 0 {
            currentIndex = 0
        }                
    }
    
}
