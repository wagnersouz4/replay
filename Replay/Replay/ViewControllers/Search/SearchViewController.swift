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
    fileprivate var data = [SearchContent]()

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
        let nib = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupSearchBar() {
        searchBar.delegate = self
    }

    fileprivate func searchForContent(with keyword: String) {
        let target = TMDbService.search(page: 1, query: keyword)
        loadContentList(using: target, mappingTo: SearchContent.self) { [weak self] contentList in
            if let loadedContent = contentList {
                self?.reloadCollectionData(with: loadedContent)
            }
        }
    }

    fileprivate func loadDefaultContent() {
        /// By default the search page will be laoded with the most popular movies
        loadContentList(using: TMDbService.popularMovies(page: 1),
                        mappingTo: GridContent.self) { [weak self] contentList in
            if let loadedContent = contentList {
                let searchContentList = loadedContent.flatMap { SearchContent($0, with: .movie) }
                self?.reloadCollectionData(with: searchContentList)
            }
        }
    }

    private func reloadCollectionData(with contentList: [SearchContent]?) {
        data = contentList ?? []
        collectionView.reloadData()
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count >= 3 {
            searchForContent(with: searchText)
        } else {
            loadDefaultContent()
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.isEmpty {
            loadDefaultContent()
        }
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath)

        let currentData = data[indexPath.row]

        cell.setup(description: nil, backgroundImageUrl: currentData.imageUrl, copyrightImage: nil)

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
