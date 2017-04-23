//
//  MovieViewController.swift
//  Replay
//
//  Created by Wagner Souza on 5/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var tableViewDelegateDataSource: GridTableViewDelegateDataSource!
    private var collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource!

    var sections: [GridSection]!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createSections()
        loadContent()
        reloadData()
    }

    private func configureUI() {
        /// Removing space between navigation bar and the tableView
        automaticallyAdjustsScrollViewInsets = false

        tableView.backgroundColor = .background
        view.backgroundColor = .background
        defaultConfigurationFor(navigationController?.navigationBar)
        navigationItem.title = "Movies"
    }

    private func createSections() {
        sections = [GridSection]()

        sections.append(GridSection(title: "In theaters",
                                layout: Grid(view).landscapeLayout,
                                showContentDescription: true,
                                target: TMDbService.nowPlayingMovies))

        sections.append(GridSection(title: "Most popular",
                                layout: Grid(view).portraitLayout,
                                target: TMDbService.popularMovies))

        sections.append(GridSection(title: "Top rated",
                                layout: Grid(view).portraitLayout,
                                target: TMDbService.topRatedMovies))

        sections.append(GridSection(title: "Upcoming",
                                layout: Grid(view).portraitLayout,
                                target: TMDbService.upcomingMovies))
    }

    private func loadContent() {
        collectionViewDelegateDataSource = GridCollectionViewDelegateDataSource(sections: sections,
                                                                                didSelect: didSelect)
        tableViewDelegateDataSource = GridTableViewDelegateDataSource(
            sections: sections, collectionViewDelegateDataSource: collectionViewDelegateDataSource)
    }

    private func reloadData() {
        tableView.delegate = tableViewDelegateDataSource
        tableView.dataSource = tableViewDelegateDataSource
    }

    private func didSelect(_ content: GridContent) {
        performSegue(withIdentifier: "MovieDetailSegue", sender: content.contentId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieId = sender as? Int else { fatalError("A movie must have an id!")}

        guard let movieVC = segue.destination as? MovieDetailViewController else {
            fatalError("The destination ViewController must be MovieDetailViewController")
        }

        movieVC.movieId = movieId
    }
}
