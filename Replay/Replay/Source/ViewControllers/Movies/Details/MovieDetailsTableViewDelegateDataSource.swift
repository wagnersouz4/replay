//
//  MovieDetailsTableDelegateDataSource.swift
//  Replay
//
//  Created by Wagner Souza on 6/05/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class MovieDetailsTableDelegateDataSource: NSObject {
    fileprivate var movie: Movie?
    fileprivate let view: UIView
    fileprivate var collectionDelegateDataSource: MovieDetailsCollectionDelegateDataSource?

    init(view: UIView) {
        self.view = view
        collectionDelegateDataSource = MovieDetailsCollectionDelegateDataSource(view: view)
    }

    func setMovie(_ movie: Movie) {
        self.movie = movie
        collectionDelegateDataSource?.setMovie(movie)
    }

    fileprivate var movieSubtitle: String {
        guard let movie = movie else { return "" }
        return MovieHelper.createSubtitleFor(movie)
    }
}

extension MovieDetailsTableDelegateDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 3) ? "Videos" : nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movie == nil) ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let movie = movie else { fatalError("Movie has not been initialized") }

        switch indexPath.section {
        /// Movie's Title
        case 0:
            let titleSubtitleCell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: TitleSubTitleTableViewCell.identifier, for: indexPath)
            titleSubtitleCell.setup(title: movie.title, subtitle: movieSubtitle)
            return titleSubtitleCell
        /// Movie's backdrops
        case 1:
            let cell = GridTableViewCell(reuseIdentifier: GridTableViewCell.identifier, orientation: .landscape)
            return cell
        /// Movie's Overview
        case 2:
            let titleTextCell: TitleTextTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: TitleTextTableViewCell.identifier, for: indexPath)
            titleTextCell.setup(title: "Overview", text: movie.overview)
            return titleTextCell
        /// Movie's Videos
        case 3:
            let cell = GridTableViewCell(reuseIdentifier: GridTableViewCell.identifier, orientation: .landscape)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MovieDetailsTableDelegateDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        switch indexPath.section {
        case 1, 3:
            let gridCell = cell.asGridTableViewCell()
            if let delegateDataSource = collectionDelegateDataSource {
                gridCell.setCollectionView(dataSource: delegateDataSource,
                                           delegate: delegateDataSource,
                                           section: indexPath.section)
            }

        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 1, 3:
            return GridHelper(view).landscapeLayout.tableViewHeight
        default:
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return GridHelper(view).landscapeLayout.tableViewHeight
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 3, let headerView = view as? UITableViewHeaderFooterView {
            headerView.setupWithDefaults()
        }
    }
}
