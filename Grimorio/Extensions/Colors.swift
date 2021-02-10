//
//  Colors.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 04/02/21.
//  Copyright © 2021 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: - Color Hex Code Approach
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    // MARK: - Custom Colors
    static var raisenBlack: UIColor { return UIColor(hex: "#231F20")! }
    
    static var fieryRose: UIColor { return UIColor(hex: "#EF626C")! }
    
    static var redSalsa: UIColor { return UIColor(hex: "#EA5455")! }
    
    static var mintCream: UIColor { return UIColor(hex: "#F2F7F2")! }
    
    static var sunGlow: UIColor { return UIColor(hex: "#FFD23F")! }
    }
