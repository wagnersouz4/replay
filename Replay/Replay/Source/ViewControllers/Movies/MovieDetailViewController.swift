////
////  MovieDetailViewController.swift
////  Replay
////
////  Created by Wagner Souza on 10/04/17.
////  Copyright © 2017 Wagner Souza. All rights reserved.
////
//
//import UIKit
//import PINRemoteImage
//
//class MovieDetailViewController: UIViewController {
//
//    @IBOutlet weak var spinner: UIActivityIndicatorView!
//    @IBOutlet weak var tableView: UITableView!
//
//    var movieId: Int!
//
//    fileprivate var movie: Movie?
//
//    fileprivate var movieSubtitle: String {
//        guard let movie = movie else { return "" }
//
//        let duration = minutesToHourMin(movie.runtime)
//        let genres = movie.genres.joined(separator: ", ")
//        let date = movie.releaseDate.format("d MMM yyyy")
//
//        return "\(duration.hours)hr(s)\(duration.minutes)min | \(genres) | \(date)"
//    }
//
//    override func viewDidLoad() {
//        configureUI()
//        setupTableView()
//        loadDetails()
//    }
//
//    private func configureUI() {
//        automaticallyAdjustsScrollViewInsets = false
//        view.backgroundColor = .background
//        spinner.color = .highlighted
//        spinner.hidesWhenStopped = true
//        tableView.backgroundColor = .background
//        tableView.estimatedRowHeight = GridHelper(view).landscapeLayout.tableViewHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
//    }
//
//    private func setupTableView() {
//        let titleSubtitleNib = TitleSubTitleTableViewCell.nib
//        tableView.register(titleSubtitleNib, forCellReuseIdentifier: TitleSubTitleTableViewCell.identifier)
//
//        let titleTextNib = TitleTextTableViewCell.nib
//        tableView.register(titleTextNib, forCellReuseIdentifier: TitleTextTableViewCell.identifier)
//
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//
//    private func loadDetails() {
//        spinner.startAnimating()
//        Movie.load(with: movieId) { [weak self] movie in
//            if let movie = movie {
//                self?.movie = movie
//                self?.tableView.reloadData()
//            } else {
//                print("Could not load movie Details")
//            }
//            self?.spinner.stopAnimating()
//        }
//    }
//
//    private func minutesToHourMin(_ minutes: Int) -> (hours: Int, minutes: Int) {
//        let hour = minutes / 60
//        let min = minutes % 60
//        return (hour, min)
//    }
//}
//
//extension MovieDetailViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return (section == 3) ? "Videos" : nil
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (movie == nil) ? 0 : 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let movie = movie else { fatalError("Movie has not been initialized") }
//
//        switch indexPath.section {
//        /// Movie's Title
//        case 0:
//            let titleSubtitleCell: TitleSubTitleTableViewCell = tableView.dequeueReusableCell(
//                withIdentifier: TitleSubTitleTableViewCell.identifier, for: indexPath)
//            titleSubtitleCell.setup(title: movie.title, subtitle: movieSubtitle)
//            return titleSubtitleCell
//        /// Movie's backdrops
//        case 1:
//            let cell = GridTableViewCell(reuseIdentifier: GridTableViewCell.identifier, orientation: .landscape)
//            return cell
//        /// Movie's Overview
//        case 2:
//            let titleTextCell: TitleTextTableViewCell = tableView.dequeueReusableCell(
//                withIdentifier: TitleTextTableViewCell.identifier, for: indexPath)
//            titleTextCell.setup(title: "Overview", text: movie.overview)
//            return titleTextCell
//        /// Movie's Videos
//        case 3:
//            let cell = GridTableViewCell(reuseIdentifier: GridTableViewCell.identifier, orientation: .landscape)
//            return cell
//        default:
//            return UITableViewCell()
//        }
//    }
//}
//
//extension MovieDetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        switch indexPath.section {
//        case 1, 3:
//            guard let gridCell = cell as? GridTableViewCell else { fatalError(" Invalid TableViewCell") }
//            gridCell.setCollectionView(dataSource: self, delegate: self, section: indexPath.section)
//        default:
//            break
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        switch indexPath.section {
//        case 1, 3:
//            return GridHelper(view).landscapeLayout.tableViewHeight
//        default:
//            return UITableViewAutomaticDimension
//        }
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return GridHelper(view).landscapeLayout.tableViewHeight
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if section == 3, let headerView = view as? UITableViewHeaderFooterView {
//            headerView.textLabel?.textColor = .white
//            headerView.textLabel?.text = headerView.textLabel?.text?.capitalized
//            let fontSize: CGFloat = (UIDevice.isIPad) ? 20 : 15
//            headerView.textLabel?.font = UIFont(name: "SFUIText-Bold", size: fontSize)
//        }
//    }
//}
//
//extension MovieDetailViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let movie = movie else { fatalError("Movie has not been set.") }
//
//        guard let collection  = collectionView as? GridCollectionView else { fatalError("Invalid CollectionView") }
//
//        switch collection.section {
//        case 1:
//            return movie.backdropImagesPath.count
//        case 3:
//            return movie.videos.count
//        default:
//            return 0
//        }
//    }
//
//    public func collectionView(_ collectionView: UICollectionView,
//                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let movie = movie else { fatalError("Movie has not been set.") }
//
//        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }
//
//        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath)
//
//        switch collection.section {
//        /// backdrop
//        case 1:
//            let imagePath = movie.backdropImagesPath[indexPath.row]
//            let imageURL = TMDbHelper.createImageURL(using: imagePath)
//            cell.setup(backgroundImageUrl: imageURL, title: nil)
//
//        /// videos
//        case 3:
//            let video = movie.videos[indexPath.row]
//            let url = video.thumbnailURL
//            //cell.setup(description: nil, backgroundImageUrl: url, copyrightImage: #imageLiteral(resourceName: "youtubeLogo"))
//            cell.setup(backgroundImageUrl: url, title: nil)
//        default:
//            break
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }
//
//        if collection.section == 3 {
//            if let video = movie?.videos[indexPath.row] {
//                UIApplication.shared.open(video.url)
//            }
//        }
//    }
//}
//
//// MARK: CollectionView flow layout
//extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let layout = GridHelper(view).landscapeLayout
//        return CGSize(width: layout.size.width,
//                      height: layout.size.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//}
