//
//  GridPortraitCollectionViewCell.swift
//  Replay
//
//  Created by Wagner Souza on 28/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

protocol GridableCollectionViewCell {
    weak var imageView: UIImageView! { get set }
    weak var label: UILabel! { get set }
    weak var spinner: UIActivityIndicatorView! { get set }
}

class GridPortraitCollectionViewCell: UICollectionViewCell, GridableCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}
