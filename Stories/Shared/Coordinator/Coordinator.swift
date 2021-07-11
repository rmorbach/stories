//
//  Coordinator.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import Foundation

protocol Coordinator {
    var children: [Coordinator] { get set }
    func start()
}
