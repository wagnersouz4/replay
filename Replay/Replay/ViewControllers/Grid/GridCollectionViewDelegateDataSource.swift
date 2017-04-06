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

    fileprivate var sections: [Section]
    fileprivate let provider = MoyaProvider<TMDbService>()
    fileprivate var didSelect: DidSelectContentClosure

    /// Collection insets
    fileprivate let collectionEdgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    init(sections: [Section], didSelect: @escaping DidSelectContentClosure) {
        self.sections = sections
        self.didSelect = didSelect
    }

    fileprivate func loadContent(for section: Int, completion: @escaping ((_: [GridContent]?) -> Void)) {
        let target = sections[section].target

        provider.request(target(1)) { result in
            switch result {
            case .success(let response):
                do {
                    guard let json = try response.mapJSON() as? JSONDictionary,
                        let contentList = GridContent.fromResults(json) else { fatalError("Error while loading JSON") }
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
            let center = CGPoint(x: collectionView.frame.width/2, y: collectionView.frame.height/2)

            /// Spinner to give some feedback to the user while loading the json data (not the image)
            let spinner = UIActivityIndicatorView(frame: CGRect(x: center.x, y: center.y, width: 50, height: 50))
            spinner.color = .highlighted
            spinner.hidesWhenStopped = true
            collectionView.addSubview(spinner)

            spinner.startAnimating()
            loadContent(for: collection.section) { [weak self] newContentList in
                if let contentList = newContentList {
                    self?.sections[currentSection].contentList.append(contentsOf: contentList)
                    spinner.stopAnimating()
                    collectionView.reloadData()
                }
            }
        }
        return sections[currentSection].contentList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
            as? GridableCollectionViewCell else { fatalError("Invalid cell") }

        let content = sections[collection.section].contentList[indexPath.row]

        cell.imageView.image = #imageLiteral(resourceName: "nocover")
        /// load the right image
        cell.label.text = content.description

        guard let collectionViewCell = cell as? UICollectionViewCell else { fatalError("lol") }

        return collectionViewCell
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
        let height = section.layout.collectionViewCellSize.height
        let width = section.layout.collectionViewCellSize.width
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
