//
//  Style.swift
//  Up
//
//  Created by Tony Cioara on 4/23/19.
//

import Foundation
import UIKit

struct Style {
    
    struct Fonts {
        static let bold15 = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        static let medium18 = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        static let bold25 = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        static let bold30 = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        static let bold35 = UIFont(name: "AppleSDGothicNeo-Bold", size: 35)
        static let bold40 = UIFont(name: "AppleSDGothicNeo-Bold", size: 40)
        static let bold45 = UIFont(name: "AppleSDGothicNeo-Bold", size: 45)
    }
    
    struct Colors {
        static let calendarShade0 = UIColor.white
        static let calendarShade1 = UIColor(displayP3Red: 204 / 255, green: 255 / 255, blue: 152 / 255, alpha: 1)
        static let calendarShade2 = UIColor(displayP3Red: 185 / 255, green: 255 / 255, blue: 115 / 255, alpha: 1)
        static let calendarShade3 = UIColor(displayP3Red: 153 / 255, green: 248 / 255, blue: 57 / 255, alpha: 1)
        static let calendarShade4 = UIColor(displayP3Red: 106 / 255, green: 192 / 255, blue: 20 / 255, alpha: 1)
        static let calendarShade5 = UIColor(displayP3Red: 88 / 255, green: 154 / 255, blue: 20 / 255, alpha: 1)
        
        struct Palette01 {
            static let skyBlue = UIColor(displayP3Red: 165 / 255, green: 216 / 255, blue: 255 / 255, alpha: 1)
            static let charcoal = UIColor(displayP3Red: 44 / 255, green: 66 / 255, blue: 81 / 255, alpha: 1)
            static let lightCyan = UIColor(displayP3Red: 222 / 255, green: 255 / 255, blue: 252 / 255, alpha: 1)
            static let pureWhite = UIColor(displayP3Red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
            static let gunMetal = UIColor(displayP3Red: 14 / 255, green: 15 / 255, blue: 19 / 255, alpha: 1)
        }
    }
}
