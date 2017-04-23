//
//  TvShowViewController.swift
//  Replay
//
//  Created by Wagner Souza on 6/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TvShowViewController: UIViewController {

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
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = .background
        view.backgroundColor = .background
        defaultConfigurationFor(navigationController?.navigationBar)
        navigationItem.title = "Tv Show"
    }

    private func createSections() {
        sections = [GridSection]()
        sections.append(GridSection(title: "Airing Today",
                                layout: Grid(view).landscapeLayout,
                                target: TMDbService.tvShowsAiringToday))
        sections.append(GridSection(title: "Most Popular",
                               layout: Grid(view).portraitLayout,
                               target: TMDbService.popularTvShows))
        sections.append(GridSection(title: "Top Rated",
                                layout: Grid(view).portraitLayout,
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
        print(content.description)
    }

}
