//
//  TitleTextTableViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 17/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TitleTextTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    private func configureUI() {
        backgroundColor = .background
        titleLabel.textColor = .white
        textView.backgroundColor = .background
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.isSelectable = false
    }
}
