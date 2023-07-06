//
//  ViewController.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 04.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    static let secondSectionHeaderElementKind = "second-section-header-element-kind"
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    var collectionView: UICollectionView!
    var dataSource: DataSource!
    
    var headerCollectionView: UICollectionView!
    var headerCollectionViewDataSource: HeaderCollectionViewDataSource!
    
    var firstSectionItems: [ListItem] = []
    var secondSectionItems: [ListItem] = []
    var headerItems: [HeaderItem] = []
    
    var isScrollingToSelectedHeaderNumber: Bool = false
    
    enum Section: CaseIterable {
        case first
        case second
    }
    
    enum Item: Hashable {
        case firstSectionItem(ListItem)
        case secondSectionItem(ListItem)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        makeModelData()
        setupHeaderCollectionView()
        setupCollectionView()
        registerCells()
        setupDataSource()
        setupLayout()
        applySnapshot()
    }
    
    func makeModelData() {
        firstSectionItems = ListItem.makeListItems(count: 30)
        secondSectionItems = ListItem.makeListItems(count: 100)
        headerItems = HeaderItem.makeHeaderItems()
    }
    
    func setupHeaderCollectionView() {
        let headerDataSource = HeaderCollectionViewDataSource()
        headerDataSource.headerItems = headerItems
        self.headerCollectionViewDataSource = headerDataSource
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
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: ViewController.secondSectionHeaderElementKind,
            withReuseIdentifier: HeaderView.identifier
        )
    }
    
    func setupDataSource() {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .firstSectionItem(let listItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as! ListCell
                cell.configure(with: listItem)
                return cell
            case .secondSectionItem(let listItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as! ListCell
                cell.configure(with: listItem)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: Self.secondSectionHeaderElementKind,
                withReuseIdentifier: HeaderView.identifier, for: indexPath
            ) as! HeaderView
            
            headerView.collectionView.dataSource = self.headerCollectionViewDataSource
            headerView.collectionView.collectionViewLayout = self.headerCollectionViewLayout()
            headerView.collectionView.delegate = self
            self.headerCollectionView = headerView.collectionView
            self.headerCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)

            return headerView
        }
        
        self.dataSource = dataSource
        collectionView.dataSource = dataSource
    }
    
    func setupLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            if sectionIndex == 0 {
                return self.firstSectionLayout()
            } else {
                return self.secondSectionLayout()
            }
        }
        collectionView.collectionViewLayout = layout
    }
    
    func firstSectionLayout() -> NSCollectionLayoutSection {
        let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.0))
        let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
        
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(1.0))
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitem: trailingItem, count: 2)
        nestedGroup.interItemSpacing = .fixed(8)
        
        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingItem, nestedGroup])
        containerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
        
    func secondSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: ViewController.secondSectionHeaderElementKind,
                                                                     alignment: .top)
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]
        return section
    }
    
    func headerCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(firstSectionItems.map { .firstSectionItem($0) }, toSection: .first)
        snapshot.appendItems(secondSectionItems.map { .secondSectionItem($0) }, toSection: .second)
        self.dataSource.apply(snapshot)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            print("Main collectionView")
        } else if collectionView == headerCollectionView {
            isScrollingToSelectedHeaderNumber = true
            let item = headerItems[indexPath.row]
            self.collectionView.scrollToItem(at: IndexPath(row: item.number, section: 1), at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard collectionView == self.collectionView else { return }
        
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let item = dataSource.snapshot().itemIdentifiers(inSection: section)[indexPath.row]
        
        switch item {
        case .firstSectionItem:
            return
        case .secondSectionItem(let listItem):
            if let matchingHeaderItemIndex = headerItems.enumerated().filter({ $0.element.number == listItem.number}).first?.offset, headerCollectionView != nil,
               isScrollingToSelectedHeaderNumber == false
            {
                let matchingHeaderItemIndexPath = IndexPath(row: matchingHeaderItemIndex, section: 0)
//                headerCollectionView.scrollToItem(at: matchingHeaderItemIndexPath, at: .top, animated: true)
                headerCollectionView.selectItem(at: matchingHeaderItemIndexPath, animated: true, scrollPosition: .top)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == collectionView as UIScrollView {
            isScrollingToSelectedHeaderNumber = false
        }
    }
}

