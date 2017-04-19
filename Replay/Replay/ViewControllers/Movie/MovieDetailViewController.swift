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

    fileprivate var backdrops = [BackdropImage]()
    fileprivate var movie: Movie?

    fileprivate var filteredVideos: [Video] {
        guard let movie = movie else { return [] }
        return movie.videos.filter { $0.type == "Trailer" || $0.type == "Teaser" }
    }

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
        tableView.estimatedRowHeight = 40
    }

    private func setupTableView() {
        let titleSubtitleNib = UINib(nibName: "TitleSubTitleTableViewCell", bundle: nil)
        tableView.register(titleSubtitleNib, forCellReuseIdentifier: "TitleSubTitleTableViewCell")

        let titleTextNib = UINib(nibName: "TitleTextTableViewCell", bundle: nil)
        tableView.register(titleTextNib, forCellReuseIdentifier: "TitleTextTableViewCell")

        tableView.dataSource = self
        tableView.delegate = self
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movie == nil {
            loadMovieDetails()
            return 0
        }

        return  1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        // Movie Title
        case 0:
            let cell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TitleSubTitleTableViewCell", for: indexPath)
            cell.title.text = movie?.title
            cell.subTitle.text = movieSubTitle
            return cell
        // Movie backdrops
        case 1:
            let cell = GridTableViewCell(reuseIdentifier: "MovieTableViewCell#Backdrop", orientation: .landscape)
            return cell
        // Movie Overview
        case 2:
            let cell: TitleTextTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TitleTextTableViewCell", for: indexPath)
            cell.titleLabel.text = "Overview"
            cell.textView.text = movie?.overview
            return cell
        // Movie Videos
        case 3:
            let cell = GridTableViewCell(reuseIdentifier: "MovieTableViewCell#Videos", orientation: .landscape)
            return cell
        default:
            print("hum")
            return UITableViewCell()
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        switch indexPath.section {
        case 1, 3:
            guard let cell = cell as? GridTableViewCell else { fatalError(" Invalid TableViewCell") }
            cell.setCollectionView(dataSource: self, delegate: self, section: indexPath.section)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1, 3:
            return Grid(view).landscapeLayout.tableViewHeight
        default:
            return UITableViewAutomaticDimension
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movie = movie else { fatalError("Movie has not been set.") }

        guard let collection  = collectionView as? GridCollectionView else { fatalError("Invalid CollectionView") }

        switch collection.section {
        case 1:
            return movie.backdropImages.count
        case 3:
            return filteredVideos.count
        default:
            return 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movie = movie else { fatalError("Movie has not been set.") }

        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        let cell: GridLandscapeCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath)
        cell.titleView.isHidden = true

        switch collection.section {
        // backdrop
        case 1:
            let backdropImage = movie.backdropImages[indexPath.row]
            let size: TMDbSize = (UIDevice.isIPad) ? .w500 : .w300

            let url = createImageURL(using: backdropImage.filePath, with: size)
            return loadGridImage(using: cell, with: url)
        // videos
        case 3:
            let video = filteredVideos[indexPath.row]
            let url = video.thumbnailURL
            return loadGridImage(using: cell, with: url)
        default:
            return UICollectionViewCell()
        }
    }

    private func loadGridImage(using gridCell: GridableCollectionViewCell, with url: URL) -> UICollectionViewCell {

        gridCell.spinner.color = .highlighted
        gridCell.spinner.hidesWhenStopped = true
        gridCell.spinner.startAnimating()
        gridCell.label.isHidden = true
        /// Loading the image progressively see more at: https://github.com/pinterest/PINRemoteImage
        gridCell.imageView.pin_updateWithProgress = true
        gridCell.imageView.pin_setImage(from: url) {  _ in
            gridCell.spinner.stopAnimating()
        }

        guard let cell = gridCell as? UICollectionViewCell else {
            fatalError("Invalid Cell")
        }

        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let layout = Grid(view).landscapeLayout
        return CGSize(width: layout.collectionViewCellSize.width,
                      height: layout.collectionViewCellSize.height)
    }
}
