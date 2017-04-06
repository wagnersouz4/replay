//
//  TVViewController.swift
//  Replay
//
//  Created by Wagner Souza on 6/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TVViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var tableViewDelegateDataSource: GridTableViewDelegateDataSource!
    private var collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource!

    var sections: [Section]!

    override func viewDidLoad() {
        configureUI()
        createSections()
        loadContent()
        reloadData()
    }

    private func configureUI() {
        tableView.backgroundColor = .background
    }

    private func createSections() {
        sections = [Section]()
        sections.append(Section(title: "Airing Today",
                                layout: Grid(view).landscapeLayout,
                                target: TMDbService.airingToday))
        sections.append(Section(title: "Most Popular",
                               layout: Grid(view).portraitLayout,
                               target: TMDbService.popularOnTV))
        sections.append(Section(title: "Top Rated",
                                layout: Grid(view).portraitLayout,
                                target: TMDbService.topRatedOnTV))
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
