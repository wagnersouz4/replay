//
//  UICollectionViewExtension.swift
//  Replay
//
//  Created by Wagner Souza on 12/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

/// Extension to avoid the usage of guard every time a cell needs to be dequeued
extension UICollectionView {
    func dequeueReusableCell<T>(withReuseIdentifier identifier: String,
                                for indexpath: IndexPath) -> T where T: UICollectionViewCell {

        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexpath) as? T else {
            fatalError("Error while casting cell as \(T.self)")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<T>(ofKind elementKind: String,
                                             withReuseIdentifier identifier: String,
                                             for indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let reusableView = self.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                       withReuseIdentifier: identifier,
                                                                       for: indexPath) as? T else {
            fatalError("Error while casting reusableView as \(T.self)")
        }

        return reusableView
    }
}
