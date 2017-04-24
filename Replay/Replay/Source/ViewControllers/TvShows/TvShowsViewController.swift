//
//  TvShowsViewController.swift
//  Replay
//
//  Created by Wagner Souza on 6/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TvShowsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var tableViewDelegateDataSource: GridTableViewDelegateDataSource!
    private var collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource!

    private var landscapeLayout: GridLayout {
        return GridHelper(view).landscapeLayout
    }

    private var portraitLayout: GridLayout {
        return GridHelper(view).portraitLayout
    }

    var sections: [GridSection]!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createSections()
        loadContent()
        reloadData()
    }

    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = .background
        view.backgroundColor = .background
        defaultConfigurationFor(navigationController?.navigationBar)
        navigationItem.title = "Tv Show"
    }

    private func createSections() {
        sections = [GridSection]()

        sections.append(GridSection(title: "Airing Today",
                                layout: landscapeLayout,
                                showContentsTitle: true,
                                target: TMDbService.tvShowsAiringToday))
        sections.append(GridSection(title: "Most Popular",
                               layout: portraitLayout,
                               target: TMDbService.popularTvShows))
        sections.append(GridSection(title: "Top Rated",
                                layout: portraitLayout,
                                target: TMDbService.topRatedTvShows))
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

    private func didSelect(content: GridContent) {
        print(content.title)
    }

}
