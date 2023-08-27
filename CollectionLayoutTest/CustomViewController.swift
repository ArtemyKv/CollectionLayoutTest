//
//  CustomViewController.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 26.08.2023.
//

import UIKit

class CustomViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionViewLayout: CustomLayout!
    
    var firstSectionItems: [ListItem] = []
    var secondSectionItems: [ListItem] = []
    var headerItems: [HeaderItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        makeModelData()
        setupCollectionView()
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
    }

    
    private func setupCollectionView() {
        collectionViewLayout = CustomLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func makeModelData() {
        firstSectionItems = ListItem.makeListItems(count: 30)
        secondSectionItems = ListItem.makeListItems(count: 100)
        headerItems = HeaderItem.makeHeaderItems()
    }

}

extension CustomViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return firstSectionItems.count
        case 1:
            return secondSectionItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as! ListCell
        let listItem = indexPath.section == 0 ? firstSectionItems[indexPath.row] : secondSectionItems[indexPath.row]
        cell.configure(with: listItem)
        return cell
    }
    
    
}
