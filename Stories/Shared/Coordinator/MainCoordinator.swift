//
//  MainCoordinator.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let storiesRepository: IStoriesRepository
    private var fetchedStories: StoriesLinkedList?
    private var currentStories: StoriesNode?
    
    init(withNavigationController
            navigationController: UINavigationController,
         repository: IStoriesRepository = StoriesRepositoryMock()) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
        self.storiesRepository = repository
    }
    
    func start() {
        // Fetch stories
        storiesRepository.fetchStories { state in
            switch state {
            case .failure(_):
                // TODO
                break
            case .success(let stories):
                self.fetchedStories = stories
                self.currentStories = self.fetchedStories?.first
                DispatchQueue.main.async {
                    self.showStories()
                }
            }
        }
        
    }
    
    private func showStories() {
        guard let node = currentStories else {
            return
        }
        
        let viewController = StoriesViewController(withStories: node.value,
                                                   delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }
        
}

extension MainCoordinator: StoriesViewControllerDelegate {
    func didFinishPresentingStories() {
        guard let node = currentStories?.next else {
            // No more stories to show
            let coordinator = FinishedStoriesCoordinator(withNavigationController: self.navigationController)
            children.append(coordinator)
            coordinator.start()
            return
        }
        
        currentStories = node
        showStories()
                        
    }
    func didFailPresenting(url: URL) {
        
    }
}
