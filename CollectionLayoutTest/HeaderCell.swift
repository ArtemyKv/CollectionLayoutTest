//
//  HeaderCell.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 04.07.2023.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    static let identifier = "HeaderCell"
    
    override var isSelected: Bool {
        didSet {
            selectionView.backgroundColor = isSelected ? .red : .clear
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let selectionView: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.contentView.addSubview(selectionView)
        self.contentView.addSubview(label)
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with headerItem: HeaderItem) {
        label.text = String(headerItem.number)
        contentView.backgroundColor = headerItem.color
    }
}
