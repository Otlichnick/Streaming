//
//  TabBarAssembly.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import UIKit

final class TabBarAssembly {
    
    func assemble(with rootModules: [UIViewController]) -> UIViewController {
        let viewModel = TabBarViewModel()
        let module = TabBarView(viewModel: viewModel)
        module.setViewControllers(rootModules, animated: true)
        return module
    }
}
