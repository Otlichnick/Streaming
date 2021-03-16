//
//  SecondScreenAssembly.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 16.03.2021.
//

import UIKit

final class SecondScreenAssembly {
    func assemble() -> UIViewController {
        let viewModel = SecondScreenViewModel()
        let module = SecondScreenView(viewModel: viewModel)
        return module
    }
}
