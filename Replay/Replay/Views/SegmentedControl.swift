//
//  SegmentedControl.swift
//  Replay
//
//  Created by Pan on 2/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import UIKit

class SegmentedControl: UISegmentedControl {

    override func awakeFromNib() {
        self.tintColor = .highlighted
        self.removeAllSegments()
    }

}
