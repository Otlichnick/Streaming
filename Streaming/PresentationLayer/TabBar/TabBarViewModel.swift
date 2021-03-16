//
//  TabBarViewModel.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import Foundation

final class TabBarViewModel {
    var titles: [String] = [
        ModelConstants.firstTabTitle,
        ModelConstants.secondTabTitle
    ]    
}

// MARK: - Constants
extension TabBarViewModel {
    private enum ModelConstants {
        static let firstTabTitle = "HOME"
        static let secondTabTitle = "SCREEN2"
    }
}
