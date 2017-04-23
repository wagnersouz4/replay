//
//  DateExtension.swift
//  Replay
//
//  Created by Wagner Souza on 12/04/17.
//  Copyright © 2017 Wagner Souza. All rights reserved.
//

import Foundation

extension Date {
    func format(_ dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return  formatter.string(from: self)
    }
}
