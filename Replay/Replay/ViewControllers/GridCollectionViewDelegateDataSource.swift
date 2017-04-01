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

    fileprivate var sections: [Section]
    fileprivate let provider = MoyaProvider<TMDbService>()

    /// Collection insets
    fileprivate let collectionEdgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    init(sections: [Section]) {
        self.sections = sections
    }

    fileprivate func loadContent(for section: Int, completion: @escaping ((_: [IntroContent]?) -> Void)) {
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

// MARK: CollectionView delegate and dataSource
extension GridCollectionViewDelegateDataSource: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collection = collectionView as? GridCollectionView,
            let currentSection = collection.section else { fatalError("Invalid collection") }

        if sections[currentSection].contentList.isEmpty {
            loadContent(for: collection.section) { [weak self] newContentList in
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
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionViewCell", for: indexPath) as? GridCollectionViewCell
            else { fatalError("Invalid cell") }

        let content = sections[collection.section].contentList[indexPath.row]

        cell.imageView.image = #imageLiteral(resourceName: "noCover")
        if let imageURL = content.imageURL {
            /// Loading the image progressively see more at: https://github.com/pinterest/PINRemoteImage
            cell.spinner.color = .highlighted
            cell.spinner.hidesWhenStopped = true
            cell.spinner.startAnimating()
            cell.imageView.pin_updateWithProgress = true
            cell.imageView.pin_setImage(from: imageURL) { _ in
                cell.spinner.stopAnimating()
            }
        }
        cell.label.text = content.description

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }
        let section = sections[collection.section]
        let content = section.contentList[indexPath.row]
        /// todo: show detailed info
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
        let height = 210.0
        /// Keeping aspect ratio as the image from TMDb is 300x444
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
