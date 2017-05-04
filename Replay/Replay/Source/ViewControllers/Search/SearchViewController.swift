//
//  SearchViewController.swift
//  Replay
//
//  Created by Wagner Souza on 6/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var section: GridSection!
    fileprivate var contentList = [TMDbContent]()

    fileprivate var collectionHeaderTitle: String {
        if let text = searchBar.text, text.characters.count >= 3 {
            return "Searching for \(text)"
        }
        return "Most Popular Movies"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .background
        collectionView.backgroundColor = .background
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.tintColor = .white
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search movies, tv-shows and people."
    }

    private func setupCollectionView() {
        collectionView.register(GridCollectionViewCell.nib,
                                forCellWithReuseIdentifier: GridCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupSearchBar() {
        searchBar.delegate = self
    }

    fileprivate func search(with keyword: String) {
        TMDbContent.find(with: keyword) { [weak self] searchResult in
            if let contentList = searchResult {
                self?.reload(using: contentList)
            } else {
                print("No contents with the keyword: \(keyword) were found at TMDb")
            }
        }
    }

    fileprivate func loadInitialContent() {
        /// The most popular movies will be used as initial content
        Movie.loadList(of: .mostPopular) { [weak self] movies in
            if let movies = movies {
                self?.reload(using: movies)
            } else {
                print("Error while loading most popular movies")
            }
        }
//        loadContentList(using: TMDbService.popularMovies(page: 1),
//                        mappingTo: GridContent.self) { [weak self] contentList in
//            if let loadedContent = contentList {
//                let searchContentList = loadedContent.flatMap { SearchContent($0, with: .movie) }
//                self?.reloadCollectionData(with: searchContentList)
//            }
//        }
    }

    private func reload(using contentList: [TMDbContent]) {
        self.contentList = contentList
        collectionView.reloadData()
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count >= 3 {
            search(with: searchText)
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath)

        //let content = contentList[indexPath.row]
        //cell.setup(
        //cell.setup(description: nil, backgroundImageUrl: currentData.imageUrl, copyrightImage: nil)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView: SearchCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "CollectionViewHeader",
                for: indexPath)

            headerView.titleLabel.text = collectionHeaderTitle
            return headerView
        default:
            assert(false, "Unexpected elment kind")
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 50) / 4
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
