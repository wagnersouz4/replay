//
//  GridCollectionViewDelegateDataSource.swift
//  Replay
//
//  Created by Wagner Souza on 31/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

protocol GridCollectionViewDidSelectDelegate: class {
    func didSelect(section: GridSection, at indexPath: IndexPath)
}

class GridCollectionViewDelegateDataSource: NSObject {

    fileprivate var sections: [GridSection]
    weak var didSelectDelegate: GridCollectionViewDidSelectDelegate?
    fileprivate let edgeInsets: UIEdgeInsets

    override init() {
        sections = []
        edgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        super.init()
    }

    func setSection(_ sections: [GridSection]) {
        self.sections = sections
    }
}

// MARK: CollectionView  data source
extension GridCollectionViewDelegateDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let gridCollection = collectionView.asGridCollectionView()
        return sections[gridCollection.section].contentList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let gridCollection = collectionView.asGridCollectionView()

        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath)

        let section = sections[gridCollection.section]
        let content = section.contentList[indexPath.row]

        var imageUrl: URL?
        switch section.layout.orientation {
        case .landscape:
            imageUrl = content.gridLandscapeImageUrl
        case .portrait:
            imageUrl = content.gridPortraitImageUrl
        }

        /// If there is no image or the section should show the content's title the title will be set
        var title: String?
        if imageUrl == nil || section.showContentsTitle {
            title = content.gridTitle
        }

        cell.setup(backgroundImageUrl: imageUrl, title: title)
        return cell
    }
}

// MARK: CollectionView delgate
extension GridCollectionViewDelegateDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gridCollection = collectionView.asGridCollectionView()
        let section = sections[gridCollection.section]
        didSelectDelegate?.didSelect(section: section, at: indexPath)
    }
}

// MARK: CollectionView flow layout
extension GridCollectionViewDelegateDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridCollection = collectionView.asGridCollectionView()
        let section = sections[gridCollection.section]
        return CGSize(width: section.layout.size.width, height: section.layout.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.bottom
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.right
    }
}
