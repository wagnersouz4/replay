//
//  NavigationController.swift
//  Replay
//
//  Created by Wagner Souza on 29/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation
import UIKit
class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationBar.clipsToBounds = true
        navigationBar.barStyle = .black
        navigationBar.barTintColor = ReplayColors.defaultBackground
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: ReplayColors.titleGreen,
            NSFontAttributeName: UIFont(name: ".SFUIText-Medium", size: 15)!
        ]

        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        searchButton.tintColor = ReplayColors.titleGreen

        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = searchButton

        navigationBar.items = [navigationItem]
    }
}
