//
//  FinishedStoriesView.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import UIKit

final class FinishedStoriesView: UIView {

    private lazy var uiMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No more stories to show"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        
    }
}

extension FinishedStoriesView: CodeView {
    func setupExtraConfigurations() {
        uiMessageLabel.isUserInteractionEnabled = true
        backgroundColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTouchesRequired = 2
        uiMessageLabel.addGestureRecognizer(tap)
    }
    func setupComponents() {
        addSubview(uiMessageLabel)
    }
    func setupConstraints() {
        uiMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: 20.0).isActive = true
        uiMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -20.0).isActive = true
        uiMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
