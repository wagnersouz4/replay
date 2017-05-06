//
//  MovieDetailsCollectionDelegateDataSource.swift
//  Replay
//
//  Created by Wagner Souza on 6/05/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class MovieDetailsCollectionDelegateDataSource: NSObject {
    fileprivate var movie: Movie?
    fileprivate let edgeInsets: UIEdgeInsets
    fileprivate let view: UIView

    init(view: UIView) {
        self.view = view
        edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func setMovie(_ movie: Movie) {
        self.movie = movie
    }
}

extension MovieDetailsCollectionDelegateDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movie = movie else { fatalError("Movie has not been set.") }

        let gridCollection  = collectionView.asGridCollectionView()

        switch gridCollection.section {
        case 1:
            return movie.backdropImagesPath.count
        case 3:
            return movie.videos.count
        default:
            return 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movie = movie else { fatalError("Movie has not been set.") }

        let gridCollection = collectionView.asGridCollectionView()

        let cell: GridCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath)

        switch gridCollection.section {
        /// backdrop
        case 1:
            let imagePath = movie.backdropImagesPath[indexPath.row]
            let imageURL = TMDbHelper.createImageURL(using: imagePath)
            cell.setup(backgroundImageUrl: imageURL, title: nil)

        /// videos
        case 3:
            let video = movie.videos[indexPath.row]
            let url = video.thumbnailURL
            //cell.setup(description: nil, backgroundImageUrl: url, copyrightImage: #imageLiteral(resourceName: "youtubeLogo"))
            cell.setup(backgroundImageUrl: url, title: nil)
        default:
            break
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gridCollection = collectionView.asGridCollectionView()
        if gridCollection.section == 3 {
            if let video = movie?.videos[indexPath.row] {
                /// As there is no device available for testing in the moment,
                /// the best approach to avoid memory leaks is to use safari to load youtube videos
                UIApplication.shared.open(video.url)
            }
        }
    }
}

// MARK: CollectionView flow layout
extension MovieDetailsCollectionDelegateDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = GridHelper(view).landscapeLayout
        return CGSize(width: layout.size.width,
                      height: layout.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.bottom
    }
}
