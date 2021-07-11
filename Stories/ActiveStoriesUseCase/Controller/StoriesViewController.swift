//
//  ViewController.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import UIKit

protocol StoriesViewControllerDelegate: StoriesViewDelegate { }

final class StoriesViewController: UIViewController {
    
    private let stories: StoriesTO
    private weak var delegate: StoriesViewControllerDelegate?
    
    init(withStories stories: StoriesTO,
         delegate: StoriesViewControllerDelegate?) {
        self.stories = stories
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = StoriesView(stories: self.stories, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (view as? StoriesView)?.start()
    }
            
}

extension StoriesViewController: StoriesViewDelegate {
    func didFinishPresentingStories() {
        delegate?.didFinishPresentingStories()
    }
    
    func didFailPresenting(url: URL) {
        
    }
}
