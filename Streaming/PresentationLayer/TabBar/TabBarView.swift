//
//  TabBarView.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import UIKit

final class TabBarView: UITabBarController {
    private let viewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLayout()
        bindViewModel()
    }
}

// MARK: - Private methods
extension TabBarView {
    private func setupLayout() {
        let offset = UIOffset(horizontal: .zero, vertical: -15)
        
        tabBar.tintColor = .white
        tabBar.items?.forEach({ $0.titlePositionAdjustment = offset })
    }
    
    private func bindViewModel() {
        guard
            let items = tabBar.items,
            items.count == 2 else {
            return
        }
        
        items.enumerated().forEach { $1.title = viewModel.titles[$0] }
    }
}


