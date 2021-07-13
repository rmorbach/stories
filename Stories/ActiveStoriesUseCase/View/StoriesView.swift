//
//  StoriesView.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import UIKit
import Kingfisher

protocol StoriesViewDelegate: AnyObject {
    func didFinishPresentingStories()
    func didFailPresenting(url: URL)
}

final class StoriesView: UIView {
    
    enum Direction {
        case backwards, forward
    }

    // time between stories
    private var timeout: TimeInterval
    
    private weak var delegate: StoriesViewDelegate?
    private let stories: StoriesTO
    private var currentIndex = 0
    
    private var animator: UIViewPropertyAnimator = .init()
    
    private lazy var uiProgressStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var uiStoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var uiUserDataStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10.0
        return stack
    }()
    
    private lazy var uiUsernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var uiUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var uiDatetimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var uiMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    init(stories: StoriesTO,
         delegate: StoriesViewDelegate?,
         timeout: TimeInterval = 5) {
        self.stories = stories
        self.delegate = delegate
        self.timeout = timeout
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func currentProgressView() -> ProgressView? {
        guard currentIndex < uiProgressStack.arrangedSubviews.count,
              currentIndex >= 0 else {
             return nil
        }
        guard let progressView = uiProgressStack.arrangedSubviews[currentIndex] as? ProgressView else {
            return nil
        }
        return progressView
    }
    
    func start() {
        
        guard let progressView = currentProgressView() else {
            return
        }
        
        progressView.setProgress(0.0, animated: false)
        
        if animator.isRunning {
            animator.stopAnimation(false)
        }
        animator.finishAnimation(at: .current)
        
        animator = UIViewPropertyAnimator(duration: timeout, curve: .easeInOut, animations: {
            progressView.setProgress(1.0)
        })
        
        animator.addCompletion { position in
            switch position {
            case .end:
                self.navigate(to: .forward)
            default: break
            }
        }
        
        animator.startAnimation()
        
    }
    
    private func updateContent(completion: @escaping(Bool)->Void) {

        // Navigate back throught all stories
        guard currentIndex >= 0 else {
            completion(false)
            return
        }
        
        guard currentIndex < stories.posts.count else {
            completion(false)
            delegate?.didFinishPresentingStories()
            return
        }
        let post = stories.posts[currentIndex]
        let resource = ImageResource(downloadURL: post.photoUrl)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date(timeIntervalSince1970: post.datetime / 1000)
        
        uiDatetimeLabel.text = formatter.string(from: date)
        
        uiMessageLabel.text = post.message
        
        uiStoryImageView.kf.indicatorType = .activity
        uiStoryImageView.startAnimating()
        
        uiStoryImageView.kf.setImage(with: resource, placeholder: nil, options: nil) { result in
            switch result {
            case .success(let image):
                self.uiStoryImageView.image = image.image
            default: break
            }
            completion(true)
        }
                
    }
    
    private func navigate(to direction: Direction) {
        switch direction {
        case .forward:
            currentIndex += 1
        case .backwards:
            currentIndex -= 1
        }
        
        if currentIndex < 0 {
            currentIndex = 0
        }
        
        updateContent { valid in
            DispatchQueue.main.async {
                if valid {
                    self.start()
                }
            }
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            animator.pauseAnimation()
        case .ended:
            animator.startAnimation()
        default: break
        }
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: uiStoryImageView)
        animator.stopAnimation(false)
        if location.x > uiStoryImageView.bounds.width / 2 {
            // Forward
            navigate(to: .forward)
        } else {            
            currentProgressView()?.setProgress(0.0, animated: false)
            navigate(to: .backwards)
        }
    }
    
}

extension StoriesView: CodeView {
    func setupConstraints() {
        
        let layoutMargins = self.safeAreaLayoutGuide
        
        uiUserDataStack.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: 8.0).isActive = true
        uiUserDataStack.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -8.0).isActive = true
        uiUserDataStack.topAnchor.constraint(equalTo: layoutMargins.topAnchor, constant: 8.0).isActive = true
        
        uiUserImageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        uiUserImageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        uiProgressStack.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: 8.0).isActive = true
        uiProgressStack.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -8.0).isActive = true
        uiProgressStack.topAnchor.constraint(equalTo: uiUserDataStack.bottomAnchor, constant: 8.0).isActive = true
        
        
        uiStoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uiStoryImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: 16.0).isActive = true
        uiStoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -16.0).isActive = true
        uiStoryImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        uiMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        uiMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        uiMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0).isActive = true
    }
    
    func setupComponents() {
        let userTextStackView = UIStackView()
        userTextStackView.axis = .vertical
        userTextStackView.translatesAutoresizingMaskIntoConstraints = false
        
        userTextStackView.addArrangedSubview(uiUsernameLabel)
        userTextStackView.addArrangedSubview(uiDatetimeLabel)
        
        uiUserDataStack.addArrangedSubview(uiUserImageView)
        uiUserDataStack.addArrangedSubview(userTextStackView)
        
        stories.posts.forEach { _ in
            let view = ProgressView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
            view.backgroundColor = .white
            uiProgressStack.addArrangedSubview(view)
        }
                        
        addSubview(uiUserDataStack)
        
        addSubview(uiProgressStack)
        
        addSubview(uiStoryImageView)
        
        addSubview(uiMessageLabel)
        
    }
    
    func setupExtraConfigurations() {
        backgroundColor = .black
        uiUsernameLabel.text = stories.user.name
        guard stories.posts.isEmpty == false else { return }
        currentIndex = -1
        navigate(to: .forward)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        uiStoryImageView.isUserInteractionEnabled = true
        uiStoryImageView.addGestureRecognizer(tap)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longpress.minimumPressDuration = 0.1
        uiStoryImageView.addGestureRecognizer(longpress)
                
        let userImageResource = ImageResource(downloadURL: stories.user.photoUrl)
        uiUserImageView.kf.setImage(with: userImageResource)
                
    }
}

