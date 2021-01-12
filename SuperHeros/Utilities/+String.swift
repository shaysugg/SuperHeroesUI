//
//  +String.swift
//  SuperHeros
//
//  Created by Sha Yan on 1/12/21.
//

import Foundation
import UIKit

extension Optional where Wrapped == String {
    func CGFloatValue() -> CGFloat? {
        guard let self = self else { return nil }
        guard let double = Double(self) else { return nil }
        return CGFloat(double)
    }
}
