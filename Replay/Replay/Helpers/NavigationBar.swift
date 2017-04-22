//
//  NavigationBar.swift
//  Replay
//
//  Created by Wagner Souza on 20/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

/// Configuring a navigationBar with defaults
func defaultConfigurationFor(_ navigationBar: UINavigationBar?) {
    navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    navigationBar?.barTintColor = .darkestBackground
    navigationBar?.tintColor = .white
    navigationBar?.isTranslucent = true
    navigationBar?.clipsToBounds = true
}
