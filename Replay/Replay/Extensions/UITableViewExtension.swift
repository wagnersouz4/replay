//
//  UITableViewExtension.swift
//  Replay
//
//  Created by Wagner Souza on 12/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T>(withIdentifier identifier: String,
                                for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Error while casting a UITableViewCell as \(T.self)")
        }
        return cell
    }
}
