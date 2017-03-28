//
//  IntroTableViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 26/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class IndexedCollectionView: UICollectionView {
    var section: Int!
}

class IntroTableViewCell: UITableViewCell {

    @IBOutlet private var collectionView: IndexedCollectionView!

    func setCollectionView(dataSource: UICollectionViewDataSource,
                           delegate: UICollectionViewDelegate,
                           indexPath: IndexPath) {

        collectionView.section = indexPath.section

        if collectionView.dataSource == nil {
            collectionView.dataSource = dataSource
        }

        if collectionView.delegate == nil {
            collectionView.delegate = delegate
        }
    }
}
