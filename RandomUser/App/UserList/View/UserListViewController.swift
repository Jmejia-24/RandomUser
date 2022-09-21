//
//  UserListViewController.swift
//  RandomUser
//
//  Created by Byron Mejia on 9/16/22.
//

import UIKit
import Combine
import SDWebImage

final class UserListViewController: UITableViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, User>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User>
    
    private var subscription: AnyCancellable?
    private let viewModel: UserListViewModel
    private var searchController = UISearchController(searchResultsController: nil)
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindUI()
    }
    
    // MARK: - Private methods
    
    private func setUI() {
        view.backgroundColor = .white
        title = "Users"
        tableView.rowHeight = 70
        tableView.prefetchDataSource = self
        viewModel.loadData()
        configureSearchController()
    }
    
    private func bindUI() {
        subscription = viewModel.userListSubject.sink { [unowned self] completion in
            switch completion {
                case .finished:
                    print("Received completion in VC", completion)
                case .failure(let error):
                    presentAlert(with: error)
            }
        } receiveValue: { [unowned self] users in
            applySnapshot(users: users)
        }
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = localizedString(.searchField)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: Diffable data source

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: tableView) { [unowned self] _, _, user -> UITableViewCell in
    
            let cell = UITableViewCell()
            var configuration = cell.defaultContentConfiguration()
        
            SDWebImageManager.shared.loadImage(with: URL(string: user.picture?.thumbnail ?? ""), options: .retryFailed, progress: nil) { image, _, _, _, _, _ in
                configuration.image = image
                configuration.imageProperties.maximumSize = .init(width: 60, height: 60)
                configuration.imageProperties.cornerRadius = 30
                cell.contentConfiguration = configuration
            }
            
            configuration.text =  "\(user.name?.first ?? "") \(user.name?.last ?? "")"
            configuration.secondaryText = "\(user.gender?.capitalized ?? "") (\(user.dob?.age ?? 0))"
            cell.contentConfiguration = configuration
            
            return cell
        }
        return dataSource
    }()
    
    private func applySnapshot(users: [User]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(users, toSection: $0) }
        dataSource.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapItem(model: user)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchData(for: indexPaths)
    }
}

extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchUser(with: searchController.searchBar.text)
    }
}

extension UserListViewController: Localization {
    
    func localizedString(_ key: LocalizationPropertiesKey) -> String {
        return key.localizedString
    }
    
    enum LocalizationPropertiesKey {
        case searchField
        
        var localizedString: String {
            switch self {
                case .searchField: return NSLocalizedString("Search User", comment: "Placeholder text in searchbar homescreen")
            }
        }
    }
}
