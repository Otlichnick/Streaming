//
//  MainAssembly.swift
//  Aster
//
//  Created by Daniil Miroshnichenko on 01.02.2021.
//

import UIKit

final class MainAssembly {
    private let serviceLocator: ServiceLocatorProtocol
    
    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
    }
    
    func assemble() -> UIViewController {
        let view = MainView()
        let interactor = MainInteractor(
            streamService: serviceLocator.streamService,
            playbackURLComposer: serviceLocator.playbackURLComposer
        )
        
        let presenter = MainPresenter(
            view: view,
            interactor: interactor,
            playerManager: serviceLocator.playerManager
        )
        
        view.presenter = presenter
        
        return view
    }
}
