//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Koty Stannard on 1/5/22.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
