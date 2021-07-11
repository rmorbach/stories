//
//  CodeView.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import Foundation

protocol CodeView {
    func setup()
    func setupConstraints()
    func setupComponents()
    func setupExtraConfigurations()
}
extension CodeView {
    func setup() {
        setupComponents()
        setupConstraints()
        setupExtraConfigurations()
    }
}

