//
//  FinishedStoriesCoordinator.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import UIKit

final class FinishedStoriesCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    var children: [Coordinator] = []
    
    init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = FinishedStoriesViewController()        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

