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

    // time between stories
    private var timeout: TimeInterval
    
    private weak var delegate: StoriesViewDelegate?

    private var animator: UIViewPropertyAnimator = .init()
    
    private lazy var uiProgressStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
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
    
    private let viewModel: StoryViewModelProtocol
    
    init(delegate: StoriesViewDelegate?,
         timeout: TimeInterval = 5,
         viewModel: StoryViewModelProtocol) {
        self.delegate = delegate
        self.timeout = timeout
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func currentProgressView() -> ProgressView? {
        guard viewModel.currentIndex < uiProgressStack.arrangedSubviews.count,
              viewModel.currentIndex >= 0 else {
             return nil
        }
        guard let progressView = uiProgressStack.arrangedSubviews[viewModel.currentIndex] as? ProgressView else {
            return nil
        }
        return progressView
    }
    
    func start() {
        
        resetCurrentProgressView()
        let progressView = currentProgressView()
         
        if animator.isRunning {
            animator.stopAnimation(false)
        }
        animator.finishAnimation(at: .current)
        
        animator = UIViewPropertyAnimator(duration: timeout, curve: .easeInOut, animations: {
            progressView?.setProgress(1.0)
        })
        
        animator.addCompletion { position in
            switch position {
            case .end:
                self.navigate(to: Direction.forward)
            default: break
            }
        }
        
        animator.startAnimation()
    }
    
    private func resetCurrentProgressView() {
        currentProgressView()?.setProgress(0.0, animated: false)
    }
    
    private func updateContent(completion: @escaping(Bool)->Void) {

        // Navigate back throught all stories
        guard viewModel.currentIndex >= 0 else {
            completion(false)
            return
        }
        
        guard let post = viewModel.post(at: viewModel.currentIndex) else {
            completion(false)
            delegate?.didFinishPresentingStories()
            return
        }
        
        let resource = ImageResource(downloadURL: viewModel.url(forPost: post))
                
        uiDatetimeLabel.text = viewModel.dateTime(forPost: post)
        uiMessageLabel.text = viewModel.message(forPost: post)
        
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
        viewModel.navigate(to: direction)
        
        updateContent { valid in
            DispatchQueue.main.async {
                if valid {
                    self.start()
                }
                // TODO
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
            navigate(to: Direction.forward)
        } else {            
            resetCurrentProgressView()
            navigate(to: Direction.backwards)
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
        
        viewModel.posts.forEach { _ in
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
        uiUsernameLabel.text = viewModel.userName
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        uiStoryImageView.isUserInteractionEnabled = true
        uiStoryImageView.addGestureRecognizer(tap)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longpress.minimumPressDuration = 0.1
        uiStoryImageView.addGestureRecognizer(longpress)
                
        let userImageResource = ImageResource(downloadURL: viewModel.userPhoto)
        uiUserImageView.kf.setImage(with: userImageResource)
                
        guard viewModel.posts.isEmpty == false else { return }
        navigate(to: .forward)
                
    }
}

