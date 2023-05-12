//
//  UsersViewController.swift
//  Messager
//
//  Created by Артём on 01.12.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {
    
    var users = [MUser]()
    private var usersListener: ListenerRegistration?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>!
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(numberOfPeople: Int) -> String {
            switch self {
            case .users:
                return "\(numberOfPeople) people nearby"
            }
        }
    }
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        usersListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(signOutTapped))
        
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { result in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        })
    }
    
    @objc private func signOutTapped() {
        let alertController = UIAlertController(title: nil, message: "Are you sure to sign out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOut = UIAlertAction(title: "Sign out", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.currentKeyWindow?.rootViewController = AuthViewController()
            } catch {
                print("Error signing out: ", error.localizedDescription)
            }
        }
        alertController.addAction(cancel)
        alertController.addAction(signOut)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .backgroundColor
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(UsersCell.self, forCellWithReuseIdentifier: UsersCell.reuseId)
        collectionView.delegate = self
    }
    
    private func reloadData(with searchText: String?) {
        let filteredUsers = users.filter { $0.contains(text: searchText) }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapShot.appendSections([.users])
        snapShot.appendItems(filteredUsers, toSection: .users)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
}

// MARK: - Create Data Source
extension PeopleViewController {
   
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, user in
            guard let section = Section(rawValue: indexPath.section) else {return nil}
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UsersCell.self, with: user, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else {return nil}
            guard let section = Section(rawValue: indexPath.section) else {return nil}
            let numberOfPeople = self.dataSource.snapshot().numberOfItems(inSection: .users)
            sectionHeader.configure(text: section.description(numberOfPeople: numberOfPeople), font: .systemFont(ofSize: 36, weight: .light), textColor: .black)
            return sectionHeader
        }
    }
}

// MARK: - Create Compositional Layout
extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {  section, layoutEnvironment in
            
            guard let section = Section(rawValue: section) else {return nil}
            switch section {
            case .users:
                return self.createUsersSectionLayout()
            }
        }
        return layout
    }
    
    private func createUsersSectionLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 15, leading: 15, bottom: 0, trailing: 15)
        
        let sectionHeader = createSectionHeaderLayout()
        section.boundarySupplementaryItems = [sectionHeader]
      
        return section
    }
    
    private func createSectionHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
}

// MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
        print(searchText)
    }
}

// MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else {return}
        let profileVC = ProfileViewController(mUser: user)
        present(profileVC, animated: true, completion: nil)
    }
}


