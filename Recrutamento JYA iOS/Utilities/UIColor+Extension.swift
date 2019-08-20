//
//  UIColor+Extension.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit

extension UIColor {
    static func hex(value: UInt32) -> UIColor {
        let red = CGFloat((value & 0xFF0000) >> 16)
        let green = CGFloat((value & 0x00FF00) >> 8)
        let blue = CGFloat(value & 0x0000FF)
        return UIColor.rgba(red, green, blue)
    }
    
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    enum App {
        static let primary = UIColor.hex(value: 0xDE9E24)
        static let background = UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1.0)
        static let navigationBackground = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
    }
}
