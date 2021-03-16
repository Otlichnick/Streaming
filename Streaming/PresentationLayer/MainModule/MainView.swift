//
//  ViewController.swift
//  Aster
//
//  Created by Daniil Miroshnichenko on 01.02.2021.
//

import UIKit
import AVKit

final class MainView: UIViewController, MainViewProtocol {
    private lazy var placeholderView: UIView = {
        let placeholderView = UIView(frame: .zero)
        placeholderView.layer.cornerRadius = 8
        placeholderView.backgroundColor = .darkGray
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderView)
        
        return placeholderView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 60
        table.separatorStyle = .none
        table.allowsSelection = false
        table.dataSource = self
        table.delegate = self
        table.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseId)
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        
        return table
    }()
    
    private lazy var rightNavBarButton: UIBarButtonItem = {
        return  UIBarButtonItem(
            title: "Stream Key",
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(self.navigationItemTapped(_:))
        )
    }()
    
    var presenter: MainPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    
        presenter?.didLoadView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.viewWillDisappear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.viewDidAppear()
    }
    
    // MARK: MainViewProtocol
    func renderUI(with title: String) {
        navigationItem.title = title
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension MainView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.dataSource.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter,
              let section = presenter.dataSource[safe: section] else {
            return .zero
        }
        
        return section.rows.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId, for: indexPath) as? TextCell,
            let presenter = presenter,
            let section = presenter.dataSource[safe: indexPath.section],
            let text =  section.rows[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.label.text = text
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let presenter = presenter,
            let section = presenter.dataSource[safe: section] else {
            return nil
        }
        
        let headerView = HeaderView()
        headerView.titleLabel.text = section.section
        return headerView
    }
}

// MARK: - Private methods
extension MainView {
    private func setupLayout() {
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = rightNavBarButton

        addConstraints()
    }
    
    @objc
    private func navigationItemTapped(_ sender: UIBarButtonItem!) {
        let alert = UIAlertController(
            title: "Stream key",
            message: presenter?.currentStreamKey,
            preferredStyle: UIAlertController.Style.alert)
        
        let copyAction = UIAlertAction(
            title: "Copy",
            style: UIAlertAction.Style.default,
            handler: { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                UIPasteboard.general.string = self.presenter?.currentStreamKey
            })

        alert.addAction(copyAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            placeholderView.heightAnchor.constraint(equalToConstant: presenter?.playerViewHeight ?? .zero),
            
            tableView.topAnchor.constraint(equalTo: placeholderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
