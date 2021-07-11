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
    private var fetchedStories: [StoriesTO] = []
    private var currentIndex: Int = 0
    
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
                break
                // TODO
            case .success(let stories):
                currentIndex = 0
                self.fetchedStories = stories
                DispatchQueue.main.async {
                    self.showStories(index: 0)
                }
            }
        }
        
    }
    
    private func showStories(index: Int) {
        let viewController = StoriesViewController(withStories: fetchedStories[index],
                                                   delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }
        
}

extension MainCoordinator: StoriesViewControllerDelegate {
    func didFinishPresentingStories() {
        currentIndex += 1
        if currentIndex < fetchedStories.count {
            showStories(index: currentIndex)
            return
        }
        
        let coordinator = FinishedStoriesCoordinator(withNavigationController: self.navigationController)
        children.append(coordinator)
        coordinator.start()
        
    }
    func didFailPresenting(url: URL) {
        
    }
}
