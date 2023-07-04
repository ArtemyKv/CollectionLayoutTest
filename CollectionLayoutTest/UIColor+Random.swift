//
//  UIColor+Random.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 04.07.2023.
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0)
    }
}
