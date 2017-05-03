//
//  GridCollectionViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 5/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit
import PINRemoteImage

class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    private func configureUI() {
        spinner.hidesWhenStopped = true
        spinner.color = .highlighted

        backgroundImageView.pin_updateWithProgress = true
        backgroundImageView.contentMode = .scaleToFill

        /// By default the titleView is hidden, and will only be shown 
        /// when there is title or the there is no background image.
        titleView.backgroundColor = .black
        titleView.alpha = 0.65
        titleView.isHidden = true

        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        let fontSize: CGFloat = (UIDevice.isIPad) ? 20 : 15
        titleLabel.font = UIFont(name: "UISFText-Light", size: fontSize)
    }

    func setup(backgroundImageUrl: URL?, title: String?) {

        /// Setting the title if it's not nil
        if let title = title {
            titleView.isHidden = false
            titleLabel.text = title
        }

        if let imageUrl = backgroundImageUrl {
            loadBackgroundImage(with: imageUrl)
        }
    }

    private func loadBackgroundImage(with url: URL) {
        spinner.startAnimating()
        /// Loading the image progressively see more at: https://github.com/pinterest/PINRemoteImage
        backgroundImageView.pin_setImage(from: url) { [weak self] _ in
            self?.spinner.stopAnimating()
        }
    }
 }
