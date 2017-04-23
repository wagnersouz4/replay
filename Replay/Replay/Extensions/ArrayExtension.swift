//
//  ArrayExtension.swift
//  Replay
//
//  Created by Wagner Souza on 12/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

extension Array where Element == Genre {
    func joined(separator: String) -> String {
        return self.map { $0.name }.joined(separator: separator)
    }
}
