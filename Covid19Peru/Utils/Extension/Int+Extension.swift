//
//  Int+Extension.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/18/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

