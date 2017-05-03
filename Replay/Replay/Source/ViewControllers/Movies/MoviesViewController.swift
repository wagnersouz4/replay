//
//  MoviesViewController.swift
//  Replay
//
//  Created by Wagner Souza on 5/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    enum SectionIndex: Int, CustomStringConvertible {
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
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private var tableViewDelegateDataSource: GridTableViewDelegateDataSource!
    private var collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource!

    private var landscapeLayout: GridLayout {
        return GridHelper(view).landscapeLayout
    }

    private var portraitLayout: GridLayout {
        return GridHelper(view).portraitLayout
    }

    private var sections = [GridSection]()
    private var totalSections: Int {
        return 4
    }

    /// The attribute will be incremented as each section's content is loaded
    private var loadedSections = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createSections()
    }

    private func configureUI() {
        /// Removing space between navigation bar and the tableView
        automaticallyAdjustsScrollViewInsets = false

        tableView.backgroundColor = .background
        view.backgroundColor = .background
        defaultConfigurationFor(navigationController?.navigationBar)
        navigationItem.title = "Movies"
    }

    private func loadContentForSection(_ index: SectionIndex) {
        var category: Movie.Category

        switch index {
        case .inTheaters:
            category = .nowPlaying
        case .mostPopular:
            category = .mostPopular
        case .topRated:
            category = .topRated
        case .upcoming:
            category = .upcoming
        }

        Movie.loadList(category) { [weak self] movies in
            if let movies = movies {
                self?.sections[index.rawValue].contentList = movies
                self?.addLoadedSection()
            } else {
                print("Error to load content for section: \(index.description)")
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
        collectionViewDelegateDataSource =
            GridCollectionViewDelegateDataSource(sections: sections)

        collectionViewDelegateDataSource.delegate = self

        tableViewDelegateDataSource =
            GridTableViewDelegateDataSource(
            sections: sections, collectionViewDelegateDataSource:collectionViewDelegateDataSource)

        tableView.delegate = tableViewDelegateDataSource
        tableView.dataSource = tableViewDelegateDataSource
        tableView.reloadData()

        spinner.stopAnimating()
    }

    private func createSections() {
        /// Creating sections with no content
        sections.append(GridSection(title: SectionIndex.inTheaters.description,
                                    layout: landscapeLayout,
                                    showContentsTitle: true))

        sections.append(GridSection(title: SectionIndex.mostPopular.description,
                                    layout: portraitLayout))

        sections.append(GridSection(title: SectionIndex.topRated.description,
                                    layout: portraitLayout))

        sections.append(GridSection(title: SectionIndex.upcoming.description,
                                    layout: portraitLayout))

        /// Loading each section's content
        /// The spinner will stop when the content for every section has been loaded
        spinner.startAnimating()
        loadContentForSection(.inTheaters)
        loadContentForSection(.mostPopular)
        loadContentForSection(.topRated)
        loadContentForSection(.upcoming)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieId = sender as? Int else { fatalError("A movie must have an id!")}

        guard let movieVC = segue.destination as? MovieDetailViewController else {
            fatalError("The destination ViewController must be MovieDetailViewController")
        }

        movieVC.movieId = movieId
    }
}

extension MoviesViewController: GridCollectionViewDidSelectDelegate {
    func didSelect(section: GridSection, at indexPath: IndexPath) {
        let movie = section.contentList[indexPath.row]
        performSegue(withIdentifier: "MovieDetailSegue", sender: movie.identifier)
    }
}
