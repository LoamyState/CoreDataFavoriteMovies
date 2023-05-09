//
//  FavoritesViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/3/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    private let movieController = MovieController.shared
    private var datasource: UITableViewDiffableDataSource<Int, Movie>!
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search a movie title"
        sc.searchBar.delegate = self
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFavoriteMovies()
        var snapshot = datasource.snapshot()
        guard !snapshot.sectionIdentifiers.isEmpty else { return }
        snapshot.reloadSections([0])
        datasource?.apply(snapshot)
    }
}

private extension FavoritesViewController {
    
    func setUpTableView() {
        tableView.backgroundView = backgroundView
        setUpDataSource()
        tableView.register(UINib(nibName: MovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    func setUpDataSource() {
        datasource = UITableViewDiffableDataSource<Int, Movie>(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
            cell.update(with: movie) {
                self.toggleFavorite(movie)
            }
            return cell
        }

    }
    
    func fetchFavoriteMovies() {
        let searchString = searchController.searchBar.text ?? ""
        Task {
            let searchResults = try? movieController.fetchFavorites(with: searchString)
            applyNewSnapshot(from: searchResults ?? [])
        }
    }
    
    func applyNewSnapshot(from movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        datasource?.apply(snapshot, animatingDifferences: true)
        tableView.backgroundView = movies.isEmpty ? backgroundView : nil
    }
    
    func toggleFavorite(_ movie: Movie) {
        removeFavorite(movie)
    }
    
    func removeFavorite(_ movie: Movie) {
        MovieController.shared.unfavoriteMovie(movie)
        var snapshot = datasource.snapshot()
        snapshot.deleteItems([movie])
        datasource?.apply(snapshot, animatingDifferences: true)
    }
    
}

extension FavoritesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.isEmpty {
            fetchFavoriteMovies()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchFavoriteMovies()
    }
    
}
