//
//  GridCollectionViewDelegateDataSource.swift
//  Replay
//
//  Created by Wagner Souza on 31/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit
import Moya
import PINRemoteImage

class GridCollectionViewDelegateDataSource: NSObject {

    typealias DidSelectContentClosure = (_: GridContent) -> Void

    fileprivate var sections: [GridSection]
    fileprivate let provider = MoyaProvider<TMDbService>()
    fileprivate var didSelect: DidSelectContentClosure

    /// Collection insets
    fileprivate let collectionEdgeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    init(sections: [GridSection], didSelect: @escaping DidSelectContentClosure) {
        self.sections = sections
        self.didSelect = didSelect
    }
}

// MARK: CollectionView delegate and dataSource
extension GridCollectionViewDelegateDataSource: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collection = collectionView as? GridCollectionView,
            let currentSection = collection.section else { fatalError("Invalid collection") }

        let section = sections[currentSection]

        if section.contentList.isEmpty {
            let center = CGPoint(x: collectionView.frame.width/2, y: collectionView.frame.height/2)

            /// Spinner to give some feedback to the user while loading the json data (not the image)
            let spinner = UIActivityIndicatorView(frame: CGRect(x: center.x, y: center.y, width: 50, height: 50))
            spinner.color = .highlighted
            spinner.hidesWhenStopped = true
            collectionView.addSubview(spinner)

            spinner.startAnimating()
            loadContentList(using: section.target(1), mappingTo: GridContent.self) { [weak self] newContentList in
                if let contentList = newContentList {
                    self?.sections[currentSection].contentList.append(contentsOf: contentList)
                    spinner.stopAnimating()
                    collectionView.reloadData()
                }
            }
        }
        return section.contentList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath)
            as? GridCollectionViewCell else { fatalError("Invalid cell") }

        let section = sections[collection.section]
        let content = section.contentList[indexPath.row]

        let size: TMDbSize = (UIDevice.isIPad) ? .w500 : .w300
        let orientation = section.layout.orientation
        let imageUrl = content.imageURL(orientation: orientation, size: size)

        /// Depening on the section configuration or if the imageUrl is nil the content description will displayed
        let description = (imageUrl == nil || section.showContentDescription ) ? content.description : nil

        cell.setup(description: description, backgroundImageUrl: imageUrl, copyrightImage: nil)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }
        let section = sections[collection.section]
        let content = section.contentList[indexPath.row]

        /// The class holding the delegate will be responsible to act when a content is selected
        didSelect(content)
    }
}

// MARK: CollectionView flow layout
extension GridCollectionViewDelegateDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionEdgeInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }
        let section = sections[collection.section]
        let height = section.layout.size.height
        let width = section.layout.size.width
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
