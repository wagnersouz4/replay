//
//  UIColorExtension.swift
//  Replay
//
//  Created by Wagner Souza on 30/03/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

extension UIColor {
    open class var background: UIColor {
        return UIColor(colorLiteralRed:  28/255, green: 28/255, blue: 28/255, alpha: 1)
    }

    open class var darkestBackground: UIColor {
        return UIColor(colorLiteralRed:  10/255, green: 10/255, blue: 10/255, alpha: 1)
    }

    open class var darkBackground: UIColor {
        return UIColor(colorLiteralRed:  25/255, green: 25/255, blue: 25/255, alpha: 1)
    }

    open class var highlighted: UIColor {
        return UIColor(colorLiteralRed: 0, green: 211/255, blue: 115/255, alpha: 1)
    }
}
