//
//  HeaderView.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 15.03.2021.
//

import UIKit

final class HeaderView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methdos
extension HeaderView {
    private func setupLayout() {
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
