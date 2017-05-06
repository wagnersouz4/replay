//
//  UITableViewHeaderFooterViewExtension.swift
//  Replay
//
//  Created by Wagner Souza on 6/05/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

/// Setup a HeaderFooterView with defaults
extension UITableViewHeaderFooterView {
    func setupWithDefaults() {
        self.textLabel?.textColor = .white
        self.textLabel?.text = self.textLabel?.text?.capitalized
        let fontSize: CGFloat = (UIDevice.isIPad) ? 20 : 15
        self.textLabel?.font = UIFont(name: "SFUIText-Bold", size: fontSize)
    }
}
