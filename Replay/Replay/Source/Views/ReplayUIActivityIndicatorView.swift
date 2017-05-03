//
//  ReplayUIActivityIndicatorView.swift
//  Replay
//
//  Created by Pan on 28/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class ReplayUIActivityIndicatorView: UIActivityIndicatorView {

    override func awakeFromNib() {
        configureUI()
    }

    private func configureUI() {
        self.color = .highlighted
        self.hidesWhenStopped = true
    }

}
