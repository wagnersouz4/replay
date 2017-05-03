//
//  UICollectionViewCellExtension.swift
//  Replay
//
//  Created by Wagner Souza on 24/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

extension UICollectionViewCell: IdentifiableCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
