//
//  TvShowsViewController.swift
//  Replay
//
//  Created by Wagner Souza on 6/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TvShowsViewController: UIViewController {

    enum TvShowSection: Int, CustomStringConvertible {
        case airing = 0
        case mostPopular, topRated

        var description: String {
            switch self {
            case .airing:
                return "Airing Today"
            case .mostPopular:
                return "Most Popular"
            case .topRated:
                return "Top Rated"
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
    private var loadedSections = 0

    private var totalSections: Int {
        return 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGridComponent()
        configureTableView()
        createSections()
    }

    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = .background
        view.backgroundColor = .background
        navigationItem.title = "Tv Show"
    }

    private func configureGridComponent() {
        gridCollectionDelegateDataSource = GridCollectionViewDelegateDataSource()
        gridTableDelegateDataSource = GridTableViewDelegateDataSource()
        gridTableDelegateDataSource.setCollectionDelegateDataSource(gridCollectionDelegateDataSource)
    }

    private func configureTableView() {
        tableView.delegate = gridTableDelegateDataSource
        tableView.dataSource = gridTableDelegateDataSource
    }

    private func createSections() {
        sections = [GridSection]()
        sections.append(GridSection(title: TvShowSection.airing.description,
                                layout: landscapeLayout,
                                showContentsTitle: true))

        sections.append(GridSection(title: TvShowSection.mostPopular.description,
                               layout: portraitLayout))

        sections.append(GridSection(title: TvShowSection.topRated.description,
                                layout: portraitLayout))

        spinner.startAnimating()
        loadContentFor(section: .airing)
        loadContentFor(section: .mostPopular)
        loadContentFor(section: .topRated)
    }

    private func loadContentFor(section: TvShowSection) {
        let service: ServiceType

        switch section {
        case .airing:
            service = .airingTvShows
        case .mostPopular:
            service = .popularTvShows
        case .topRated:
            service = .topRatedTvShows
        }

        Networking.loadList(using: service) { [weak self] tvShows in
            if let tvShows = tvShows {
                self?.sections[section.rawValue].contentList = tvShows
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
        gridTableDelegateDataSource.setSections(sections)
        gridCollectionDelegateDataSource.setSection(sections)
        tableView.reloadData()
        spinner.stopAnimating()
    }
}
