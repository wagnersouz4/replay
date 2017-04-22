//
//  TitleSubTitleTableViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 11/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TitleSubTitleTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    private func configureUI() {
        titleLabel.textColor = .white
        subtitleLabel.textColor = .white
        backgroundColor = .background
    }

    func setup(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
