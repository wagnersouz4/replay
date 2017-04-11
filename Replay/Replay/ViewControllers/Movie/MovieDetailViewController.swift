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
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var tableView: UITableView!
    var movieID: Int!

    override func viewDidLoad() {
        configureUI()
        configureNavBar()
        loadMovieDetails()
    }

    private func configureUI() {
        spinner.color = .highlighted
        spinner.hidesWhenStopped = true
        view.backgroundColor = .background
        tableView.backgroundColor = .background
    }

    private func configureNavBar() {
    }

    private func test() {
        dismiss(animated: true, completion: nil)
    }

    private func loadMovieDetails() {
        let target = TMDbService.movie(movieID: movieID)
        spinner.startAnimating()
        loadContent(using: target, mappingTo: Movie.self) { [weak self] movie in
            self?.spinner.stopAnimating()
            if let movie = movie {
            }
        }

    }
}
