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
    fileprivate var movieSubTitle: String {
        guard let movie = movie else { return "" }

        let duration = minutesToHourMin(movie.runtime)
        let genres = movie.genres.joined(separator: ", ")

        let date = movie.releaseDate.format("d MMM yyyy")

        return "\(duration.hours)hr(s)\(duration.minutes)min | \(genres) | \(date)"
    }

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

    private func minutesToHourMin(_ minutes: Int) -> (hours: Int, minutes: Int) {
        let hour = minutes / 60
        let min = minutes % 60
        return (hour, min)
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movie == nil { loadMovieDetails() }
        return (movie == nil) ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "MovieTableViewCell", for: indexPath)
        cell.title.text = movie?.title
        cell.subTitle.text = movieSubTitle
        return cell
    }
}
