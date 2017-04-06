//
//  Grid.swift
//  Replay
//
//  Created by Wagner Souza on 6/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

/// Data structure containing the grid layout specification
public struct GridLayout {
    let tableViewHeight: CGFloat
    let collectionViewCellOrientation: CollectionViewCellOrientation
    let collectionViewCellSize: CGSize
}

public class Grid {

    public var view: UIView

    init(_ view: UIView) {
        self.view = view
    }

    public var screenHeight: CGFloat {
        return max(view.frame.height, self.view.frame.width)
    }

    public  var screenWidth: CGFloat {
        return min(view.frame.height, view.frame.width)
    }

    public var landscapeLayout: GridLayout {
        let height = screenWidth * 0.562
        let orientation = CollectionViewCellOrientation.landscape

        let cellHeight = height - 20
        let collectionViewCellSize = CGSize(width: cellHeight * 1.78, height: cellHeight)

        return GridLayout(
            tableViewHeight: height,
            collectionViewCellOrientation: orientation,
            collectionViewCellSize: collectionViewCellSize)
    }

    public var portraitLayout: GridLayout {
        let height = screenHeight * 0.35
        let orientation = CollectionViewCellOrientation.portrait

        let cellHeight = height - 20
        let collectionViewCellSize = CGSize(width: cellHeight * 0.67, height: cellHeight)

        return GridLayout(
            tableViewHeight: height,
            collectionViewCellOrientation: orientation,
            collectionViewCellSize: collectionViewCellSize)
    }
}
