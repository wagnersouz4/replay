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
        tableView.register(nib, forCellReuseIdentifier: "TitleSubTitleTableViewCell")
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
        return 2
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
        case 0:
            let cell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TitleSubTitleTableViewCell", for: indexPath)
            cell.title.text = movie?.title
            cell.subTitle.text = movieSubTitle
            return cell

        case 1:
            let cell = GridTableViewCell(reuseIdentifier: "MovieTableViewCell#Backdrop", orientation: .landscape)
            return cell

        default:
            return UITableViewCell()
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            guard let cell = cell as? GridTableViewCell else { fatalError(" Invalid TableViewCell") }
            cell.setCollectionView(dataSource: self, delegate: self, section: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return Grid(view).landscapeLayout.tableViewHeight
        default:
            return 40
        }
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movie = movie else { fatalError("Movie has not been set.") }

        if backdrops.isEmpty {
            backdrops = movie.backdropImages
            collectionView.reloadData()
        }

        return backdrops.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movie = movie else { fatalError("Movie has not been set.") }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath)
            as? GridLandscapeCollectionViewCell else { fatalError("Invalid cell") }

        let backdropImage = movie.backdropImages[indexPath.row]
        let url = createImageURL(using: backdropImage.filePath, with: .w300)

        cell.spinner.color = .highlighted
        cell.spinner.hidesWhenStopped = true
        cell.spinner.startAnimating()
        cell.label.isHidden = true
        cell.titleView.isHidden = true
        /// Loading the image progressively see more at: https://github.com/pinterest/PINRemoteImage
        cell.imageView.pin_updateWithProgress = true
        cell.imageView.pin_setImage(from: url) { _ in
            cell.spinner.stopAnimating()
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
