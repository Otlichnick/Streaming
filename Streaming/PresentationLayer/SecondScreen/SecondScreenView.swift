//
//  SecondScreenView.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 16.03.2021.
//

import UIKit

final class SecondScreenView: UIViewController {
    private let viewModel: SecondScreenViewModel
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 60
        table.separatorStyle = .none
        table.allowsSelection = false
        table.dataSource = self
        table.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseId)
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        
        return table
    }()
    
    init(viewModel: SecondScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindViewModel()
    }
}

// MARK: - SecondScreenViewModelDelegate
extension SecondScreenView: SecondScreenViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SecondScreenView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId,
                                                       for: indexPath) as? TextCell,
            let text = viewModel.dataSource[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.label.text = text
        return cell
    }
}

// MARK: - Private methods
extension SecondScreenView {
    private func bindViewModel() {
        viewModel.delegate = self
        navigationItem.title = viewModel.title
        viewModel.setup()
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
