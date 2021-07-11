//
//  SceneDelegate.swift
//  Stories
//
//  Created by Rodrigo Morbach on 10/07/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: Coordinator?
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // Override point for customization after application launch.
        let screenSize = windowScene.coordinateSpace.bounds
        
        let appWindow = UIWindow(frame: screenSize)
        
        appWindow.windowScene = windowScene
        
        let rootViewController = UINavigationController()
        
        appWindow.rootViewController = rootViewController
        
        appWindow.makeKeyAndVisible()
        
        let mainCoordinator = MainCoordinator(withNavigationController: rootViewController)
        self.coordinator = mainCoordinator
        
        self.window = appWindow
        mainCoordinator.start()
    }
    
    
}

