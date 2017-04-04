//
//  UIStoryBoardExtension.swift
//  Replay
//
//  Created by Wagne Souza on 4/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

extension UIStoryboard {

    /// This enum accounts for the Storyboard's filename in the project
    enum Storyboard: String {
        case ReplayIphone, ReplayIpad
    }

    convenience init(using storyboard: Storyboard) {
        self.init(name: storyboard.rawValue, bundle: nil)
    }

    /// The generic type T needs to be a instance of UIViewContoller and conform to the StoryboardIdentifiable.
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        /// This is very useful as we don't need to write the guard expression every time.
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyBoardIdentifier) as? T else {
            fatalError("Error while instantitating the ViewController with identifier \(T.storyBoardIdentifier)")
        }
        return viewController
    }
}
