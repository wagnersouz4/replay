//
//  ViewControllerExtension.swift
//  Replay
//
//  Created by Wagner Souza on 4/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

/// A much better and safe way to use storyboards identifiers. 
// See more at: https://medium.com/swift-programming/7aad3883b44d
protocol StoryboardIdentifiable {
    static var storyBoardIdentifier: String { get }
}

/// Here it's assumed that you are using the the UIViewController class name as it's identifier in the IB
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyBoardIdentifier: String {
        return String(describing: self)
    }
}

/// A global extension to all UIViewControllers, so there is no needed to conform everyone
extension UIViewController: StoryboardIdentifiable { }
