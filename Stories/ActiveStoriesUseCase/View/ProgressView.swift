//
//  ProgressView.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import UIKit

final class ProgressView: UIView {
    private lazy var uiProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .white
        progressView.trackTintColor = .lightGray
        progressView.progress = 0.0
        return progressView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: Float, animated: Bool = true) {
        if animated == false {
            self.uiProgressView.progress = progress
            self.uiProgressView.layoutIfNeeded()
            return 
        }
        self.uiProgressView.setProgress(progress, animated: animated)
    }
    
    
}

extension ProgressView: CodeView {
    func setupComponents() {
        addSubview(uiProgressView)
        layer.cornerRadius = 5.0
    }
    
    func setupExtraConfigurations() {
        backgroundColor = .clear
    }
    
    func setupConstraints() {
        uiProgressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uiProgressView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        uiProgressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        uiProgressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
