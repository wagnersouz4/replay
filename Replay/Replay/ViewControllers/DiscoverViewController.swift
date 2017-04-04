//
//  DiscoverViewController.swift
//  Replay
//
//  Created by Wagner Souza on 31/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

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

        /// Inserting segments programatically as it's easier to know the index of each one,
        /// without the need to go open the storyboard.
        segmentedControl.insertSegment(withTitle: "Movies", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "TV", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Celebrities", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(loadContent), for: .valueChanged)

        /// Adding a search button to the rightBar
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(loadContent))
        searchButton.tintColor = .highlighted
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.title = "Discover"
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
        collectionViewDelegateDataSource = GridCollectionViewDelegateDataSource(sections: sections,
                                                                                didSelect: didSelect)
        tableViewDelegateDataSource = GridTableViewDelegateDataSource(
            sections: sections, collectionDelegateDataSource: collectionViewDelegateDataSource)

        if tableView.dataSource == nil {
            tableView.dataSource = tableViewDelegateDataSource
        }

        if tableView.delegate == nil {
            tableView.delegate = tableViewDelegateDataSource
        }

        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { fatalError("The segue must have a identifier!") }
        guard let contentId = sender as? Int else { fatalError("The sender should be an Int value") }
        switch identifier {
        case "MovieDetailsSegue":
            let viewController = segue.destination as? MovieDetailsViewController
            viewController?.movieID = contentId
        case "TVDetailsSegue":
            print("tv")
        case "CelebrityDetailsSegue":
            print("celebrity")
        default:
            break
        }
    }

    private func didSelect(_ content: IntroContent, with mediaType: Mediatype) {
        switch mediaType {
        case .movie:
            performSegue(withIdentifier: "MovieDetailsSegue", sender: content.contentId)
        case .tv:
            performSegue(withIdentifier: "TVDetailsSegue", sender: content.contentId)
        case .celebrity:
            performSegue(withIdentifier: "CelebrityDetailsSegue", sender: content.contentId)
        }
    }
}
