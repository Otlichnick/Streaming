//
//  SecondScreenViewModel.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 16.03.2021.
//

import Foundation

protocol SecondScreenViewModelDelegate: class {
    func reloadData()
}

final class SecondScreenViewModel {
    weak var delegate: SecondScreenViewModelDelegate?
    var dataSource = [String]()
    var title: String = "SCREEN2"
    
    func setup() {
        fillDataSource()
        delegate?.reloadData()
    }
}

// MARK: - Private methods
extension SecondScreenViewModel {
    func fillDataSource() {
        dataSource = [textStub()]
    }
    
    private func textStub() -> String {
        var stub = ""
        let text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        
        for _ in 0...10 { stub += "\(text)\n\n"}
        
        return stub
    }
}
