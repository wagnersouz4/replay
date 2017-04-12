//
//  MovieDetailViewController.swift
//  Replay
//
//  Created by Wagner Souza on 10/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit
import PINRemoteImage

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var movieID: Int!
   fileprivate var movie: Movie?

    override func viewDidLoad() {
        configureUI()
        setupTableView()
    }

    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        spinner.color = .highlighted
        spinner.hidesWhenStopped = true
        view.backgroundColor = .background
        tableView.backgroundColor = .background
    }

    private func setupTableView() {
        let nib = UINib(nibName: "TitleSubTitleTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
        tableView.dataSource = self
    }

    fileprivate func loadMovieDetails() {
        let target = TMDbService.movie(movieID: movieID)
        spinner.startAnimating()
        loadContent(using: target, mappingTo: Movie.self) { [weak self] movie in
            self?.spinner.stopAnimating()
            if let movie = movie {
                self?.movie = movie
                self?.tableView.reloadData()
            }
        }
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movie == nil { loadMovieDetails() }
        return (movie == nil) ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieTableViewCell", for: indexPath) as? TitleSubTitleTableViewCell else {
                fatalError("Invalid TableView Cell")
        }

        cell.title.text = movie?.title
        cell.subTitle.text = movie?.releaseDate

        return cell
    }
}
