//
//  TabBarController.swift
//  Replay
//
//  Created by Wagner Souza on 5/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        configureUI()
    }

    private func configureUI() {
        tabBar.barTintColor = .darkBackground
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
    }
}
