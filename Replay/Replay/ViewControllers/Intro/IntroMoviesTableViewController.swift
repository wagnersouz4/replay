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
        let target: MovieIntroTarget

        init(title: String, target: @escaping MovieIntroTarget) {
            self.movies = []
            self.title = title
            self.target = target
        }
    }

    fileprivate let provider = MoyaProvider<TMDbService>()
    fileprivate var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sections.append(Section(title: "Popular", target: TMDbService.popularMovies))
        sections.append(Section(title: "Now Playing", target: TMDbService.nowPlayingMovies))
        sections.append(Section(title: "Upcoming", target: TMDbService.upcomingMovies))
        sections.append(Section(title: "Top Rated", target: TMDbService.topRatedMovies))
    }
}

// MARK: Tableview delegate and data source
extension IntroTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Each table cell will have one identifier. 
        /// As a consequence, each section will have its own reuse queue avoiding unexpected conflits.
        let identifier = "TableCell#\(indexPath.section)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ??
            IntroTableViewCell(style: .default, reuseIdentifier: identifier)
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? IntroTableViewCell else { return }
        tableViewCell.setCollectionView(dataSource: self, delegate: self, section: indexPath.section)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

// MARK: CollectionView delegate and data source
extension IntroTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collection = collectionView as? IntroCollectionView,
            let currentSection = collection.section else { fatalError("Invalid collection") }

        if sections[currentSection].movies.isEmpty {
            loadContent(for: collection.section) {
                collectionView.reloadData()
            }
        }

        return sections[currentSection].movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView as? IntroCollectionView else { fatalError("Invalid collection") }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                            for: indexPath) as? IntroCollectionViewCell else {
                                                                fatalError("Invalid cell") }

        let movieIntro = sections[collection.section].movies[indexPath.row]
            cell.spinner.startAnimating()
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: movieIntro.posterURL) {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data: data)
                        cell.spinner.stopAnimating()
                    }
                }
            }

        return cell
    }
}

extension IntroTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 230.0
        let width = 155.40
        return CGSize(width: width, height: height)
    }
}

extension IntroTableViewController {
    func loadContent(for section: Int, completion: @escaping (() -> Void)) {
        let target = sections[section].target

        provider.request(target(1)) { [weak self] result in

            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let movies = MovieIntro.fromResults(json) else { fatalError("Error while loading JSON") }
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
