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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var copyrightImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    private func configureUI() {
        spinner.hidesWhenStopped = true
        spinner.color = .highlighted

        backgroundImageView.pin_updateWithProgress = true
        backgroundImageView.contentMode = .scaleToFill

        /// The titleView will only be visible when there is a description in the setup method
        titleView.backgroundColor = .black
        titleView.alpha = 0.65
        titleView.isHidden = true

        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center

        ///  The copyrightImage will only be visible when there is a copyright image in the setup method
        copyrightImageView.contentMode = .scaleAspectFit
        copyrightImageView.alpha = 0.5
        copyrightImageView.isHidden = true

    }

    func setup(description: String?, backgroundImageUrl: URL?, copyrightImage: UIImage?) {

        /// Setting the description if it's not nil
        if let description = description {
            titleView.isHidden = false
            descriptionLabel.text = description
        }

        if let imageUrl = backgroundImageUrl {
            loadBackgroundImage(with: imageUrl)
        }

        if let copyrightImage = copyrightImage {
            copyrightImageView.isHidden = false
            copyrightImageView.image = copyrightImage
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
