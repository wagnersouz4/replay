//
//  TitleTextTableViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 17/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class TitleTextTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!

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
        textView.textAlignment = .justified
    }

    func setup(title: String, text: String) {
        titleLabel.text = title
        textView.text = text
    }
}
