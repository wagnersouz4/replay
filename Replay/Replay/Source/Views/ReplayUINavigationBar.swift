//
//  ReplayUINavigationBar.swift
//  Replay
//
//  Created by Wagner Souza on 4/05/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class ReplayUINavigationBar: UINavigationBar {

    override func awakeFromNib() {
        configureUI()
    }

    private func configureUI() {
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        barTintColor = .darkestBackground
        tintColor = .white
        isTranslucent = true
        clipsToBounds = true
    }

}
