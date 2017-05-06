//
//  MovieDetailsViewController.swift
//  Replay
//
//  Created by Wagner Souza on 10/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var movieId: Int!

    private var movie: Movie!
    private var tableDelegateDataSource: MovieDetailsTableDelegateDataSource?

    override func viewDidLoad() {
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
        loadDetails()
    }

    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .background
        tableView.backgroundColor = .background
        tableView.estimatedRowHeight = GridHelper(view).landscapeLayout.tableViewHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func setupTableView() {
        let titleSubtitleNib = TitleSubTitleTableViewCell.nib
        tableView.register(titleSubtitleNib, forCellReuseIdentifier: TitleSubTitleTableViewCell.identifier)

        let titleTextNib = TitleTextTableViewCell.nib
        tableView.register(titleTextNib, forCellReuseIdentifier: TitleTextTableViewCell.identifier)

        tableDelegateDataSource = MovieDetailsTableDelegateDataSource(view: view)
        tableView.dataSource = tableDelegateDataSource
        tableView.delegate = tableDelegateDataSource
    }

    private func loadDetails() {
        spinner.startAnimating()
        Networking.loadMovie(id: movieId) { [weak self] movie in
            if let movie = movie {
                self?.movie = movie
                self?.showContent()
            } else {
                print("Could not load movie Details")
            }
        }
    }

    private func showContent() {
        tableDelegateDataSource?.setMovie(movie)
        tableView.reloadData()
        spinner.stopAnimating()
    }
}
