//
//  ReplayUITabBar.swift
//  Replay
//
//  Created by Wagner Souza on 23/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class ReplayUITabBar: UITabBar {
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    private func configureUI() {
        self.barTintColor = .darkBackground
        self.tintColor = .white
        self.isTranslucent = false
    }
}
