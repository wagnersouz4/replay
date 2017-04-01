//
//  IntroViewController.swift
//  Replay
//
//  Created by Wagner Souza on 31/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    private var tableViewDelegateDataSource: GridTableViewDelegateDataSource!
    private var collectionViewDelegateDataSource: GridCollectionViewDelegateDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadContent()
    }

    private func setupUI() {
        view.backgroundColor = .background
        segmentedControl.tintColor = .highlighted
        segmentedControl.removeAllSegments()

        /// Inserting segments programatically as it's easier to know the index of each one,
        /// without the need to go open the storyboard.
        segmentedControl.insertSegment(withTitle: "Movies", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "TV", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Celebrities", at: 2, animated: true)

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(loadContent), for: .valueChanged)
    }

    @objc private func loadContent() {
        var sections = [Section]()

        switch segmentedControl.selectedSegmentIndex {
        /// Movie
        case 0:
            sections.append(Section(title: "Most Popular", mediaType: .movie, target: TMDbService.popularMovies))
            sections.append(Section(title: "Top Rated", mediaType: .movie, target: TMDbService.topRatedMovies))
            sections.append(Section(title: "In Theaters", mediaType: .movie, target: TMDbService.popularMovies))
            sections.append(Section(title: "Upcoming", mediaType: .movie, target: TMDbService.upcomingMovies))
        /// TV
        case 1:
            sections.append(Section(title: "Most Popular", mediaType: .tv, target: TMDbService.popularOnTV))
            sections.append(Section(title: "Top Rated", mediaType: .tv, target: TMDbService.topRatedOnTV))
        /// Celebrities
        case 2:
            sections.append(Section(title: "Most Popular", mediaType: .celebrity, target: TMDbService.celebrities))
        default:
            break
        }

        reloadData(using: sections)
    }

    private func reloadData(using sections: [Section]) {
        collectionViewDelegateDataSource = GridCollectionViewDelegateDataSource(sections: sections)
        tableViewDelegateDataSource = GridTableViewDelegateDataSource(
            sections: sections, collectionDelegateDataSource: collectionViewDelegateDataSource)
        tableView.dataSource = tableViewDelegateDataSource
        tableView.delegate = tableViewDelegateDataSource
        tableView.reloadData()
    }
}
