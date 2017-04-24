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
    let orientation: GridOrientation
    let size: CGSize
}

public class GridHelper {

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
        let tableHeight = screenWidth * 0.562
        let orientation = GridOrientation.landscape
        let height = tableHeight * 0.9
        let size = CGSize(width: height * 1.78, height: height)

        return GridLayout(
            tableViewHeight: tableHeight,
            orientation: orientation,
            size: size)
    }

    public var portraitLayout: GridLayout {
        let tableHeight = screenHeight * 0.35
        let orientation = GridOrientation.portrait
        let height = tableHeight * 0.9
        let size = CGSize(width: height * 0.67, height: height)

        return GridLayout(
            tableViewHeight: tableHeight,
            orientation: orientation,
            size: size)
    }
}
