//
//  HeaderCell.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 04.07.2023.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    static let identifier = "HeaderCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.contentView.addSubview(label)
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with headerItem: HeaderItem) {
        label.text = String(headerItem.number)
        contentView.backgroundColor = headerItem.color
    }
}
