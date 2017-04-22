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
    let orientation: Orientation
    let size: CGSize
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
        let height = screenWidth * 0.562 - 20
        let orientation = Orientation.landscape
        let size = CGSize(width: height * 1.78, height: height)

        return GridLayout(
            tableViewHeight: height,
            orientation: orientation,
            size: size)
    }

    public var portraitLayout: GridLayout {
        let height = screenHeight * 0.35 - 20
        let orientation = Orientation.portrait
        let size = CGSize(width: height * 0.67, height: height)

        return GridLayout(
            tableViewHeight: height,
            orientation: orientation,
            size: size)
    }
}
