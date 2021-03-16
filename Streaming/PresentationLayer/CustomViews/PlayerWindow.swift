//
//  PlayerWindow.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.2021.
//

import UIKit
import AVKit

final class PlayerWindow: UIWindow {
    private var playerTopAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var playerLeadingAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var playerTrailingAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var playerHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()
    private var wasConfigured: Bool = false
    
    lazy var playerView: PlayerView = {
        let playerView = PlayerView(frame: .zero)
        playerView.backgroundColor = .black
        playerView.layer.cornerRadius = 8
        playerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerView)
        
        return playerView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.backgroundColor = .clear
        loader.translatesAutoresizingMaskIntoConstraints = false
        playerView.addSubview(loader)
        
        return loader
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Waiting for stream to start"
        playerView.addSubview(label)
        
        return label
    }()
    
    /// Height of the playerView in Position.default
    var initialHeight: CGFloat {
        return CGFloat(PlayerConstants.aspectRatio.height)
            * UIScreen.main.bounds.width
            / CGFloat(PlayerConstants.aspectRatio.width)
    }
    
    /// Player view position
    enum Position {
        /// Top large
        case `default`
        /// Left bottom corner
        case small
    }
    
    /// Set postion of the player window with animation
    /// - Parameters:
    ///     - position: New position
    func setPosition(_ position: Position) {
        switch position {
        case .default:
            if wasConfigured {
                animateToDefaultState()
            } else {
                wasConfigured.toggle()
                setupLayout()
            }
        case .small:
            animateToSmallState()
        }
    }
    
    /// Start spinner animation and show status label
    func showLoader() {
        statusLabel.isHidden = false
        loader.isHidden = false
        loader.startAnimating()
    }
    
    /// Hide spinner and status label
    func hideLoader() {
        statusLabel.isHidden = true
        loader.isHidden = true
        loader.stopAnimating()
    }
}

// MARK: - Private methods
extension PlayerWindow {
    private func setupLayout() {
        let offset = resolveTopOffset()
        
        playerTopAnchor = playerView.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        playerLeadingAnchor = playerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        playerTrailingAnchor = playerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        playerHeightAnchor = playerView.heightAnchor.constraint(equalToConstant: initialHeight)
        
        NSLayoutConstraint.activate([
            playerTopAnchor,
            playerLeadingAnchor,
            playerTrailingAnchor,
            playerHeightAnchor,
            
            loader.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: playerView.centerYAnchor),
            
            statusLabel.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: playerView.centerYAnchor, constant: 40),
        ])
    }
    
    private func animateToSmallState() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let leadingOffset = (screenWidth / 3) * 1.5
        let width = screenWidth - leadingOffset
        let height = resolveSmallStatePlayerHeight(from: width)
        
        let bottomContentHeight = PlayerConstants.tabBarHeight
            + PlayerConstants.bottomSpacing
            + height
            + PlayerConstants.statusBarHeight
        
        let topOffset = screenHeight - bottomContentHeight
        
        playerLeadingAnchor.constant = leadingOffset
        playerHeightAnchor.constant = height
        playerTopAnchor.constant = topOffset

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func animateToDefaultState() {
        playerLeadingAnchor.constant = .zero
        playerHeightAnchor.constant = initialHeight
        playerTopAnchor.constant = resolveTopOffset()

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func resolveSmallStatePlayerHeight(from width: CGFloat) -> CGFloat {
        return CGFloat(PlayerConstants.aspectRatio.height)
            * width
            / CGFloat(PlayerConstants.aspectRatio.width)
    }
    
    private func resolveTopOffset() -> CGFloat {
        guard
            let rootVC = rootViewController,
            let tabBar = rootVC as? TabBarView,
            let navigation = tabBar.viewControllers?
                .first(where: { $0 is UINavigationController })
                .map({ $0 as! UINavigationController }),
            let root = navigation.viewControllers.first else {
            return safeAreaInsets.top
        }
        
        return root.view.safeAreaInsets.top
    }
}

// MARK: - Constants
extension  PlayerWindow {
    private enum PlayerConstants {
        static let aspectRatio = (width: 4, height: 3)
        static let tabBarHeight: CGFloat = 50
        static let bottomSpacing: CGFloat = 20
        static let statusBarHeight: CGFloat = 15
    }
}
