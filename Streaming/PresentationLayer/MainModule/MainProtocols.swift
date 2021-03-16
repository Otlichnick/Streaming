//
//  MainProtocols.swift
//  Aster
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import UIKit

/// Protocol describes view interface
protocol MainViewProtocol: class {
    
    /// Method fills view with static data
    /// - Parameters:
    ///     - title: navigation bar title
    func renderUI(with title: String)
    
    /// Method reloads view's tableView
    func reloadData()
}

/// Protocol describes presenter interface
protocol MainPresenterProtocol {
    
    /// Stream key for current stream
    var currentStreamKey: String { get }
    
    /// Height of the playerView in Position.default
    var playerViewHeight: CGFloat { get }
    
    /// Models for module table data
    var dataSource: [MainDataSource] { get }
    
    /// The method is called when view trigger viewDidLoad
    func didLoadView()
    
    /// The method is called when view trigger viewWillDisappear
    func viewWillDisappear()
    
    /// The method is called when view trigger viewDidAppear
    func viewDidAppear()
}

/// Protocol describes interactor interface
protocol MainInteractorProtocol {
    
    /// Current stream
    var currentStream: StreamDTO? { get }
    
    /// Method fetchs playback URL for active stream
    /// - Parameters:
    ///     - result: completion result with playback url or error
    func fetchPlaybackURL(result: @escaping (Result<URL, Error>) -> Void)
}

