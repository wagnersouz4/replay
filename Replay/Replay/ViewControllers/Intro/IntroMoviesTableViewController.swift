//
//  IntroTableViewController.swift
//  Replay
//
//  Created by Wagner Souza on 26/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit
import Moya

class IntroTableViewController: UITableViewController {

    typealias MovieIntroTarget = (Int) -> TMDbService

    struct Section {
        var movies: [MovieIntro]
        let title: String
        let index: Int
        let target: MovieIntroTarget
        var currentPage: Int

        init(title: String, index: Int, target: @escaping MovieIntroTarget) {
            self.movies = []
            self.title = title
            self.index = index
            self.target = target
            self.currentPage = 1
        }
    }

    fileprivate let provider = MoyaProvider<TMDbService>()
    fileprivate var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sections.append(Section(title: "Popular", index: 0, target: TMDbService.popularMovies))
        sections.append(Section(title: "Now Playing", index: 1, target: TMDbService.nowPlayingMovies))
        sections.append(Section(title: "Upcoming", index: 2, target: TMDbService.upcomingMovies))
        sections.append(Section(title: "Top Rated", index: 3, target: TMDbService.topRatedMovies))
    }
}

extension IntroTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellIntro", for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? IntroTableViewCell else { return }
        tableViewCell.setCollectionView(dataSource: self, delegate: self, indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].title
    }
}

extension IntroTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collection = collectionView as? IndexedCollectionView else { fatalError("Invalid collection Type") }

        if sections[collection.section].movies.isEmpty {
            loadContent(for: collection.section) {
                collectionView.reloadData()
            }
        }
        return sections[section].movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView as? IndexedCollectionView else { fatalError("Invalid collection Type") }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellIntro",
                                                            for: indexPath) as? IntroCollectionViewCell else {
                                                                fatalError("Invalid cell type") }

        let movieIntro = sections[collection.section].movies[indexPath.row]

        if let url = movieIntro.posterURL {
            cell.spinner.startAnimating()
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                        cell.spinner.stopAnimating()
                    }
                }
            }
        }
        return cell
    }
}

extension IntroTableViewController {
    func loadContent(for section: Int, completion: @escaping (() -> Void)) {

        let target = sections[section].target
        let page = sections[section].currentPage

        provider.request(target(page)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let movies = MovieIntro.fromResults(json) else { return }
                    self?.sections[section].movies.append(contentsOf: movies)
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
