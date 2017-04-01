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

    private func setupNavigationBar() {
        /// NavigationBar Style
        navigationBar.clipsToBounds = true
        navigationBar.barStyle = .black
        navigationBar.barTintColor = .background
        navigationBar.tintColor = .highlighted

        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.highlighted,
            NSFontAttributeName: UIFont(name: ".SFUIText-Medium", size: 15)!
        ]

        /// Adding a search button to the rightBar
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchButton.tintColor = .highlighted
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = searchButton
        navigationBar.items = [navigationItem]
    }

    @objc private func search() {
        // do search
    }
}
