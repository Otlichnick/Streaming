//
//  MainPresenter.swift
//  Aster
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import UIKit

struct MainDataSource {
    let section: String
    let rows: [String]
}

final class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewProtocol?
    private let interactor: MainInteractorProtocol
    private var playerManager: PlayerManagerProtocol
    
    var dataSource = [MainDataSource]()

    var playerViewHeight: CGFloat {
        return playerManager.playerWindow.initialHeight
    }
    
    var currentStreamKey: String {
        get {
            return interactor.currentStream?.stream_key ?? ""
        }
    }
    
    init(
        view: MainViewProtocol,
        interactor: MainInteractorProtocol,
        playerManager: PlayerManagerProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.playerManager = playerManager
        self.playerManager.delegate = self
    }
    
    // MARK: MainPresenterProtocol
    func didLoadView() {
        
        fillDataSource()
        view?.renderUI(with: "HOME")
        view?.reloadData()
        
        playerManager.playerWindow.showLoader()
        interactor.fetchPlaybackURL { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let playbackURL):
                    self.playerManager.play(url: playbackURL)
                    self.playerManager.playerWindow.hideLoader()
                case .failure:
                    self.playerManager.playerWindow.hideLoader()
                }
            }
        }
    }
    
    func viewWillDisappear() {
        playerManager.playerWindow.setPosition(.small)
    }
    
    func viewDidAppear() {
        playerManager.playerWindow.setPosition(.default)
    }
}

// MARK: - PlayerManagerDelegate
extension MainPresenter: PlayerManagerDelegate {
    func didFinishStreaming() {
        playerManager.playerWindow.showLoader()
        interactor.fetchPlaybackURL { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let playbackURL):
                    self.playerManager.play(url: playbackURL)
                    self.playerManager.playerWindow.hideLoader()
                case .failure:
                    self.playerManager.playerWindow.hideLoader()
                }
            }
        }
    }
}

// MARK: - Private methods
extension MainPresenter {
    private func fillDataSource() {
        dataSource = [(MainDataSource(section: "Sapmle Title", rows: [textStub()]))]
    }
    
    private func textStub() -> String {
        return """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
    }
}
