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

    init(sections: [GridSection]) {
        self.sections = sections
    }
}

// MARK: CollectionView delegate and dataSource
extension GridCollectionViewDelegateDataSource: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        return sections[collection.section].contentList.count

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath)

        let section = sections[collection.section]
        let content = section.contentList[indexPath.row]

        let imageUrl = (section.layout.orientation == .portrait) ? content.gridPortraitImageUrl
                                                                 : content.gridLandscapeImageUrl

        //let size: TMDbSize = (UIDevice.isIPad) ? .w500 : .w300
        //let orientation = section.layout.orientation
        //let imageUrl: URL? //content.imageURL(orientation: orientation, size: size)

        /// If there is no image or the section should show the content's title the title will be set
        let title =  (imageUrl == nil || section.showContentsTitle) ? content.gridTitle : nil

        cell.setup(backgroundImageUrl: imageUrl, title: title)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }
        let section = sections[collection.section]
        didSelectDelegate?.didSelect(section: section, at: indexPath)
    }
}

// MARK: CollectionView flow layout
extension GridCollectionViewDelegateDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collection = collectionView as? GridCollectionView else { fatalError("Invalid collection") }

        let section = sections[collection.section]
        return CGSize(width: section.layout.size.width, height: section.layout.size.height)
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
