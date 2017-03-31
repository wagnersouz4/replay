//
//  IntroTableViewController.swift
//  Replay
//
//  Created by Wagner Souza on 26/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit
import Moya
import PINRemoteImage

class IntroTableViewController: UITableViewController {

    typealias TargetWithPage = (Int) -> TMDbService

    enum Mediatype {
        case movie, tvshow, celebrity
    }

    struct Section {
        var contentList: [IntroContent]
        let title: String
        let mediaType: Mediatype
        let target: TargetWithPage

        init(title: String, mediaType: Mediatype, target: @escaping TargetWithPage) {
            self.contentList = []
            self.title = title
            self.mediaType = mediaType
            self.target = target
        }
    }

    /// Content
    fileprivate let provider = MoyaProvider<TMDbService>()
    fileprivate var sections = [Section]()

    /// Collection insets
    let collectionEdgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    /// Default table height
    var defaultTableRowHeight: CGFloat = 160

    override func viewDidLoad() {
        super.viewDidLoad()
        createSections()
    }

    func createSections() {
        sections.append(Section(title: "Popular on TV", mediaType: .tvshow, target: TMDbService.popularOnTV))
        sections.append(Section(title: "Celebrities", mediaType: .celebrity, target: TMDbService.celebrities))
        sections.append(Section(title: "Upcoming Movies", mediaType: .movie, target: TMDbService.upcomingMovies))
        sections.append(Section(title: "Popular Movies", mediaType: .movie, target: TMDbService.popularMovies))
        sections.append(Section(title: "Top Rated Movies", mediaType: .movie, target: TMDbService.topRatedMovies))
    }

    func showDetailsFor(_ content: IntroContent, with mediaType: Mediatype) {
        switch mediaType {
        case .movie:
            guard let movieViewController = storyboard?.instantiateViewController(
                withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else {
                    fatalError("error while instanciating the MovieViewController")
            }
            movieViewController.movieID = content.contentId
            self.navigationController?.pushViewController(movieViewController, animated: true)
        case .celebrity:
            print("celebrity")
        case .tvshow:
            print("tv-show")
        }
    }

    func loadContent(for section: Int, completion: @escaping ((_: [IntroContent]?) -> Void)) {
        let target = sections[section].target

        provider.request(target(1)) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let contentList = IntroContent.fromResults(json) else { fatalError("Error while loading JSON") }
                    completion(contentList)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}

// MARK: Tableview delegate and data source
extension IntroTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defaultTableRowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Each table cell will have one identifier.
        /// As a consequence, each section will have its own reuse queue avoiding unexpected conflits.
        let identifier = "TableCell#\(indexPath.section)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ??
            IntroTableViewCell(style: .default, reuseIdentifier: identifier)
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? IntroTableViewCell else { return }
        tableViewCell.setCollectionView(dataSource: self, delegate: self, section: indexPath.section)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = .background
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.textAlignment = .left
    }
}

// MARK: CollectionView delegate and data source
extension IntroTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collection = collectionView as? IntroCollectionView,
            let currentSection = collection.section else { fatalError("Invalid collection") }

        if sections[currentSection].contentList.isEmpty {
            loadContent(for: collection.section) {[weak self] newContentList in
                if let contentList = newContentList {
                    self?.sections[currentSection].contentList.append(contentsOf: contentList)
                    collectionView.reloadData()
                }
            }
        }
        return sections[currentSection].contentList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView as? IntroCollectionView else { fatalError("Invalid collection") }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath) as? IntroCollectionViewCell
            else { fatalError("Invalid cell") }

        let contentIntro = sections[collection.section].contentList[indexPath.row]

        cell.imageView.image = #imageLiteral(resourceName: "noCover")
        if let imageURL = contentIntro.imageURL {
            /// Loading the image progressively see more at: https://github.com/pinterest/PINRemoteImage
            cell.spinner.color = .highlighted
            cell.spinner.hidesWhenStopped = true
            cell.spinner.startAnimating()
            cell.imageView.pin_updateWithProgress = true
            cell.imageView.pin_setImage(from: imageURL) { _ in
                cell.spinner.stopAnimating()
            }
        }
        cell.label.text = contentIntro.description

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collection = collectionView as? IntroCollectionView else { fatalError("Invalid collection") }
        let section = sections[collection.section]
        let content = section.contentList[indexPath.row]
        showDetailsFor(content, with: section.mediaType)
    }
}

// MARK: CollectionView flow layout
extension IntroTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionEdgeInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = defaultTableRowHeight - (collectionEdgeInset.left + collectionEdgeInset.right)
        let width = 0.6756 * height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
