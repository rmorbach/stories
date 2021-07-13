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


final class StoriesLinkedList {
    
    private var tail: StoriesNode?
    private var head: StoriesNode?
    
    subscript(index: Int) -> StoriesTO? {
        var node = head
        
        if node == nil { return nil }
        
        var currentIndex = 0
        repeat {
            if index == currentIndex {
                return node?.value
            }
            currentIndex += 1
            node = node?.next
        } while(node != nil)
        
        return nil
    }
        
    var count: Int {
        guard isEmpty == false else {
            return 0
        }
        
        var counter = 0
        var node = head
        repeat {
            counter += 1
            node = node?.next
        } while(node != nil)
        
        return counter
    }
    
            
    var last: StoriesNode? {
        return tail
    }
    
    var first: StoriesNode? {
        return head
    }
    
    var isEmpty: Bool {
        return head == nil
    }
        
    func append(_ value: StoriesTO) {
        let node = StoriesNode(value: value)
        
        if let tailNode = tail {
            node.previous = tailNode
            tailNode.next = node
                        
        } else {
            head = node
        }        
        tail = node
    }
}

extension StoriesLinkedList: CustomStringConvertible {
    var description: String {
        var text = "["
        var node = head
        while let nd = node {
            text += "\(nd.value)"
            node = nd.next
            if node != nil { text += ", " }
        }
        return text + "]"
    }
}


final class StoriesNode {
    
    var value: StoriesTO
    var next: StoriesNode?
    
    weak var previous: StoriesNode?
    init(value: StoriesTO, next: StoriesNode? = nil, previous: StoriesNode? = nil) {
        self.value = value
        self.next = next
        self.previous = previous
    }
}
