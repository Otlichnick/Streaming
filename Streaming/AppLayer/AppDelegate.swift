//
//  AppDelegate.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let coordinator =  DefaultCoordinator()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        coordinator.configure()
        return true
    }
}

