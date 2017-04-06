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

    private var screenHeight: CGFloat {
        return max(view.frame.height, view.frame.width)
    }

    private var screenWidth: CGFloat {
        return min(view.frame.height, view.frame.width)
    }

    private var landscapeLayout: GridLayout {
        let height = screenWidth * 0.562
        let orientation = CollectionViewCellOrientation.landscape

        let cellHeight = height - 20
        let collectionViewCellSize = CGSize(width: cellHeight * 1.78, height: cellHeight)

        return GridLayout(
            tableViewHeight: height,
            collectionViewCellOrientation: orientation,
            collectionViewCellSize: collectionViewCellSize)
    }

    private var portraitLayout: GridLayout {
        let height = screenHeight * 0.35
        let orientation = CollectionViewCellOrientation.portrait

        let cellHeight = height - 20
        let collectionViewCellSize = CGSize(width: cellHeight * 0.67, height: cellHeight)

        return GridLayout(
            tableViewHeight: height,
            collectionViewCellOrientation: orientation,
            collectionViewCellSize: collectionViewCellSize)
    }

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
        sections.append(Section(title: "In Theaters", layout: landscapeLayout, target: TMDbService.nowPlayingMovies))
        sections.append(Section(title: "Most Popular", layout: portraitLayout, target: TMDbService.popularMovies))
        sections.append(Section(title: "Top Rated", layout: portraitLayout, target: TMDbService.topRatedMovies))
        sections.append(Section(title: "Upcoming", layout: portraitLayout, target: TMDbService.upcomingMovies))
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
        print("selected \(content.contentId)")
    }
}
