//
//  GridTableView.swift
//  Replay
//
//  Created by Wagner Souza on 31/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class GridTableView: UITableView {

    override func awakeFromNib() {
        setupUI()
    }

    func setupUI() {
        backgroundColor = .background
        separatorStyle = .none
    }
}
