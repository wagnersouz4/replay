//
//  UIDeviceExtension.swift
//  Replay
//
//  Created by Wagner Souza on 6/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isIPad: Bool {
        return UIDevice.current.model == "iPad"
    }
}
