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

    var movieId: Int!

    fileprivate var backdrops = [BackdropImage]()
    fileprivate var movie: Movie?

    fileprivate var filteredVideos: [Video] {
        guard let movie = movie else { return [] }
        return movie.videos.filter { $0.type == "Trailer" || $0.type == "Teaser" }
    }

    fileprivate var movieSubtitle: String {
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
        let target = TMDbService.movie(movieId: movieId)
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 3) ? "Videos" : nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movie == nil {
            loadMovieDetails()
            return 0
        }

        return  1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let movie = movie else { fatalError("Movie has not been initialized") }

        switch indexPath.section {
        /// Movie's Title
        case 0:
            let titleSubtitleCell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TitleSubTitleTableViewCell", for: indexPath)
            titleSubtitleCell.setup(title: movie.title, subtitle: movieSubtitle)
            return titleSubtitleCell
        /// Movie's backdrops
        case 1:
            let cell = GridTableViewCell(reuseIdentifier: "MovieTableViewCell#Backdrop", orientation: .landscape)
            return cell
        /// Movie's Overview
        case 2:
            let titleTextCell: TitleTextTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TitleTextTableViewCell", for: indexPath)
            titleTextCell.setup(title: "Overview", text: movie.overview)
            return titleTextCell
        /// Movie's Videos
        case 3:
            let cell = GridTableViewCell(reuseIdentifier: "MovieTableViewCell#Videos", orientation: .landscape)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        switch indexPath.section {
        case 1, 3:
            guard let gridCell = cell as? GridTableViewCell else { fatalError(" Invalid TableViewCell") }
            gridCell.setCollectionView(dataSource: self, delegate: self, section: indexPath.section)
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

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 3, let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.text = headerView.textLabel?.text?.capitalized
            let fontSize:CGFloat = (UIDevice.isIPad) ? 20 : 15
            headerView.textLabel?.font = UIFont(name: "SFUIText-Bold", size: fontSize)
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

        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath)

        switch collection.section {
        /// backdrop
        case 1:
            let backdropImage = movie.backdropImages[indexPath.row]
            let size: TMDbSize = (UIDevice.isIPad) ? .w500 : .w300
            let url = createImageURL(using: backdropImage.filePath, with: size)

            cell.setup(description: nil, backgroundImageUrl: url, copyrightImage: nil)

        /// videos
        case 3:
            let video = filteredVideos[indexPath.row]
            let url = video.thumbnailURL
            cell.setup(description: nil, backgroundImageUrl: url, copyrightImage: #imageLiteral(resourceName: "youtubeLogo"))
        default:
            break
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        if collection.section == 3 {
            let video = filteredVideos[indexPath.row]
            UIApplication.shared.open(video.url)
        }
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
        return CGSize(width: layout.size.width,
                      height: layout.size.height)
    }
}
