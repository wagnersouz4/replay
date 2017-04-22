//
//  TvShowDetailViewController.swift
//  Replay
//
//  Created by Wagner Souza on 20/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TvShowDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var tvShowId: Int!
    fileprivate var tvShow: TvShow?

    override func viewDidLoad() {
        configureUI()
        setupTableView()
    }

    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .background
        spinner.hidesWhenStopped = true
        spinner.color = .highlighted
        tableView.backgroundColor = .background
        tableView.estimatedRowHeight = 40
    }

    private func setupTableView() {
        let titleSubtitleNib = UINib(nibName: "TitleSubTitleTableViewCell", bundle: nil)
        tableView.register(titleSubtitleNib, forCellReuseIdentifier: "TitleSubTitleTableViewCell")

        tableView.dataSource = self
        tableView.delegate = self
    }

    fileprivate func loadDetails() {
        let target = TMDbService.tvShow(tvShowId: tvShowId)
        spinner.startAnimating()
        loadContent(using: target, mappingTo: TvShow.self) { [weak self] tvShow in
            self?.spinner.stopAnimating()
            if let tvShow = tvShow {
                self?.tvShow = tvShow
                self?.tableView.reloadData()
            }
        }
    }
}

extension TvShowDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tvShow == nil {
            loadDetails()
            return 0
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let tvShow = tvShow else { fatalError("TvShow has not been set") }

        switch indexPath.section {
        // TV's title
        case 0:
            let titleSubtitleCell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TitleSubTitleTableViewCell", for: indexPath)
            titleSubtitleCell.setup(title: tvShow.name, subtitle: tvShow.name)
            return titleSubtitleCell
        default:
            return UITableViewCell()
        }
    }
}

extension TvShowDetailViewController: UITableViewDelegate {

}
