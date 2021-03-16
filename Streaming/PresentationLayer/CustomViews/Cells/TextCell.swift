//
//  TextCell.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 15.03.2021.
//

import UIKit

final class TextCell: UITableViewCell {
    static let reuseId: String = "textCell"
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
extension TextCell {
    private func setupLayot() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
