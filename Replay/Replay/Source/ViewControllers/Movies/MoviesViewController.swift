//
//  MoviesViewController.swift
//  Replay
//
//  Created by Wagner Souza on 5/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    enum MovieSection: Int, CustomStringConvertible {
        case inTheaters = 0
        case mostPopular, topRated, upcoming

        var description: String {
            switch self {
            case .inTheaters:
                return "In theaters"
            case .mostPopular:
                return "Most popular"
            case .topRated:
                return "Top rated"
            case .upcoming:
                return "Upcoming"
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: ReplayUIActivityIndicatorView!

    private var gridTableDelegateDataSource: GridTableViewDelegateDataSource!
    private var gridCollectionDelegateDataSource: GridCollectionViewDelegateDataSource!

    private var landscapeLayout: GridLayout {
        return GridHelper(view).landscapeLayout
    }

    private var portraitLayout: GridLayout {
        return GridHelper(view).portraitLayout
    }

    private var sections: [GridSection]!
    private var totalSections: Int {
        return 4
    }

    /// The attribute will be incremented as each section's content is loaded
    private var loadedSections = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGridComponent()
        configureTableView()
        createSections()
    }

    private func configureUI() {
        /// Removing space between navigation bar and the tableView
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = .background
        view.backgroundColor = .background
        navigationItem.title = "Movies"
    }

    private func configureGridComponent() {
        gridCollectionDelegateDataSource = GridCollectionViewDelegateDataSource()
        gridCollectionDelegateDataSource.didSelectDelegate = self
        gridTableDelegateDataSource = GridTableViewDelegateDataSource()
        gridTableDelegateDataSource.setCollectionDelegateDataSource(gridCollectionDelegateDataSource)
    }

    private func configureTableView() {
        tableView.delegate = gridTableDelegateDataSource
        tableView.dataSource = gridTableDelegateDataSource
    }

    private func loadContentFor(section: MovieSection) {
        var service: ServiceType

        switch section {
        case .inTheaters:
            service = .nowPlayingMovies
        case .mostPopular:
            service = .popularMovies
        case .topRated:
            service = .topRatedMovies
        case .upcoming:
            service = .upcomingMovies
        }

        Networking.loadList(using: service) { [weak self] movies in
            if let movies = movies {
                self?.sections[section.rawValue].contentList = movies
                self?.addLoadedSection()
            } else {
                print("Error to load content for section: \(section.description)")
            }
        }
    }

    private func addLoadedSection() {
        loadedSections += 1
        if loadedSections == totalSections {
            showSectionsContent()
        }
    }

    private func showSectionsContent() {
        gridCollectionDelegateDataSource.setSection(sections)
        gridTableDelegateDataSource.setSections(sections)
        tableView.reloadData()
        spinner.stopAnimating()
    }

    private func createSections() {
        /// Creating sections with no content
        sections = [GridSection]()
        sections.append(GridSection(title: MovieSection.inTheaters.description,
                                    layout: landscapeLayout,
                                    showContentsTitle: true))

        sections.append(GridSection(title: MovieSection.mostPopular.description,
                                    layout: portraitLayout))

        sections.append(GridSection(title: MovieSection.topRated.description,
                                    layout: portraitLayout))

        sections.append(GridSection(title: MovieSection.upcoming.description,
                                    layout: portraitLayout))

        /// Loading each section's content
        /// The spinner will stop when the content for every section has been loaded
        spinner.startAnimating()
        loadContentFor(section: .inTheaters)
        loadContentFor(section: .mostPopular)
        loadContentFor(section: .topRated)
        loadContentFor(section: .upcoming)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieId = sender as? Int else { fatalError("A movie must have an id!")}

        guard let movieVC = segue.destination as? MovieDetailsViewController else {
            fatalError("The destination ViewController must be type of \(MovieDetailsViewController.self)")
        }

        movieVC.movieId = movieId
    }
}

extension MoviesViewController: GridCollectionViewDidSelectDelegate {
    func didSelect(section: GridSection, at indexPath: IndexPath) {
        /// Needs a refactor in order to remove the memory leaks, as loading the details is generating memory leaks
        let movie = section.contentList[indexPath.row]
        performSegue(withIdentifier: "MovieDetailSegue", sender: movie.identifier)
    }
}
