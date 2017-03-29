//
//  IntroTableViewController.swift
//  Replay
//
//  Created by Wagner Souza on 26/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit
import Moya

class IntroTableViewController: UITableViewController {

    typealias MovieIntroTarget = (Int) -> TMDbService

    enum ContentType {
        case movie, tvshow, celebrity
    }

    struct Section {
        var contentList: [IntroContent]
        let title: String
        let contentType: ContentType
        let target: MovieIntroTarget

        init(title: String, contentType: ContentType, target: @escaping MovieIntroTarget) {
            self.contentList = []
            self.title = title
            self.contentType = contentType
            self.target = target
        }
    }

    fileprivate let provider = MoyaProvider<TMDbService>()
    fileprivate var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sections.append(Section(title: "Popular Movies", contentType: .movie, target: TMDbService.popularMovies))
        sections.append(Section(title: "Popular on TV", contentType: .tvshow, target: TMDbService.popularOnTV))
        sections.append(Section(title: "Celebrities", contentType: .celebrity, target: TMDbService.celebrities))
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = ReplayColors.IntroBackground
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
            loadContent(for: collection.section) {
                collectionView.reloadData()
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
            cell.spinner.startAnimating()
            DispatchQueue.global().async {
                let data = (contentIntro.imageURL != nil) ? try? Data(contentsOf: contentIntro.imageURL!) : nil
                    DispatchQueue.main.sync {
                        cell.imageView.image = (data != nil) ? UIImage(data: data!) : #imageLiteral(resourceName: "noCover")
                        cell.label.text = contentIntro.description
                        cell.spinner.stopAnimating()
                    }
            }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collection = collectionView as? IntroCollectionView else { fatalError("Invalid collection") }
        let content = sections[collection.section].contentList[indexPath.row]
        print(content.description)
    }

}

extension IntroTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 200.0
        let width = 0.6756756756756757 * height
        return CGSize(width: width, height: height)
    }
}

extension IntroTableViewController {
    func loadContent(for section: Int, completion: @escaping (() -> Void)) {
        let target = sections[section].target

        provider.request(target(1)) { [weak self] result in

            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let contentList = IntroContent.fromResults(json) else { fatalError("Error while loading JSON") }
                        self?.sections[section].contentList.append(contentsOf: contentList)
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
