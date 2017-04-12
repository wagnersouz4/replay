//
//  TitleSubTitleTableViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 11/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TitleSubTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    private func configureUI() {
        title.textColor = .white
        subTitle.textColor = .white
        backgroundColor = .background
    }
}
