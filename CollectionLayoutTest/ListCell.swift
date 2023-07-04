//
//  ListCell.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 04.07.2023.
//

import UIKit

final class ListCell: UICollectionViewCell {
    static let identifier = "ListCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
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
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with listItem: ListItem) {
        label.text = String(listItem.number)
        contentView.backgroundColor = listItem.color
    }
}
