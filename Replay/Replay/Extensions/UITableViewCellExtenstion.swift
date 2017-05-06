//
//  UITableViewCellExtenstion.swift
//  Replay
//
//  Created by Wagner Souza on 24/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

protocol IdentifiableCell: class {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension UITableViewCell: IdentifiableCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}

extension UITableViewCell {
    func asGridTableViewCell() -> GridTableViewCell {
        guard let gridTableCell = self as? GridTableViewCell else {
            fatalError("Error while casting:  \(self) to \(GridTableViewCell.self)")
        }
        return gridTableCell
    }
}
