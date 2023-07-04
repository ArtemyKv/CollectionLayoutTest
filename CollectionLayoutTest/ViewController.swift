//
//  ViewController.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 04.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    var collectionView: UICollectionView!
    var dataSource: DataSource!
    
    var listItems: [ListItem] = []
    var headerItems: [HeaderItem] = []
    
    enum Section: CaseIterable {
        case header
        case main
    }
    
    enum Item: Hashable {
        case header(HeaderItem)
        case list(ListItem)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        makeModelData()
        setupCollectionView()
        registerCells()
        setupDataSource()
        setupLayout()
        applySnapshot()
    }
    
    func makeModelData() {
        listItems = ListItem.makeListItems(count: 100)
        headerItems = HeaderItem.makeHeaderItems()
    }
    
    func setupCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        self.collectionView = collectionView
        collectionView.delegate = self
    }
    
    func registerCells() {
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.identifier)
    }
    
    func setupDataSource() {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .header(let headerItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
                cell.configure(with: headerItem)
                return cell
            case .list(let listItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as! ListCell
                cell.configure(with: listItem)
                return cell
            }
        }
        self.dataSource = dataSource
        collectionView.dataSource = dataSource
    }
    
    func setupLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            if sectionIndex == 0 {
                return self.headerLayoutSection()
            } else {
                return self.listLayoutSection()
            }
        }
        collectionView.collectionViewLayout = layout
    }
    
    func headerLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return section
    }
    
    func listLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(headerItems.map { .header($0) }, toSection: .header)
        snapshot.appendItems(listItems.map { .list($0) }, toSection: .main)
        self.dataSource.apply(snapshot)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        switch section {
        case .header:
            let item = dataSource.snapshot().itemIdentifiers(inSection: .header)[indexPath.row]
            switch item {
            case .header(let headerItem):
                collectionView.scrollToItem(at: IndexPath(item: headerItem.number, section: 1), at: .top, animated: true)
            default: return 
            }
        case .main:
            let item = listItems[indexPath.row]
            print("Item with number \(item.number) selected")
            //do nothing
        }
    }
}

