//
//  DefaulCoordinator.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import UIKit

final class DefaultCoordinator {
    private let serviceLocator: ServiceLocatorProtocol = ServiceLocator()
    
    func configure() {
        let window = serviceLocator.playerManager.playerWindow
        let rootModule = makeMainModule()
        window.rootViewController = rootModule
        window.makeKeyAndVisible()
    }
}

// MARK: - Private methods
extension DefaultCoordinator {
    private func makeMainModule() -> UIViewController {
        let mainTabNavigation = makeNavigation()
        let secondTabNavigation = makeNavigation()
        
        let mainAssembly = MainAssembly(serviceLocator: serviceLocator)
        
        let secondScreenModule = SecondScreenAssembly().assemble()
        let mainModule = mainAssembly.assemble()
        
        mainTabNavigation.setViewControllers([mainModule], animated: true)
        secondTabNavigation.setViewControllers([secondScreenModule], animated: true)
        
        let tabBarModule = TabBarAssembly().assemble(with: [mainTabNavigation, secondTabNavigation])
        
        return tabBarModule
    }
    
    private func makeNavigation() -> UINavigationController {
        let navigation = UINavigationController()
        navigation.navigationBar.prefersLargeTitles = true
        navigation.navigationBar.standardAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        return navigation
    }
}
