//
//  FinishedStoriesViewController.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import UIKit

final class FinishedStoriesViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = FinishedStoriesView()
    }

}
