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
        static let bold10 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 10))
        static let bold12 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 12))
        static let semibold12 = UIFont(name: "AppleSDGothicNeo-Semibold", size: widthScaleFactor(distance: 12))
        static let bold15 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 15))
        static let medium18 = UIFont(name: "AppleSDGothicNeo-Medium", size: widthScaleFactor(distance: 18))
        static let semibold18 = UIFont(name: "AppleSDGothicNeo-Semibold", size: widthScaleFactor(distance: 18))
        static let bold18 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 18))
        static let bold20 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 20))
        static let bold25 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
        static let bold30 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 30))
        static let bold35 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 35))
        static let bold40 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 40))
        static let bold45 = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 45))
    }
    
    struct Colors {
        static let calendarShade0 = UIColor.white
        static let calendarShade1 = #colorLiteral(red: 0.5450980392, green: 0.737254902, blue: 0.9529411765, alpha: 1)
        static let calendarShade2 = #colorLiteral(red: 0.2705882353, green: 0.5803921569, blue: 0.9254901961, alpha: 1)
        static let calendarShade3 = #colorLiteral(red: 0, green: 0.4274509804, blue: 0.8980392157, alpha: 1)
        static let calendarShade4 = #colorLiteral(red: 0, green: 0.3137254902, blue: 0.6549019608, alpha: 1)
        static let calendarShade5 = #colorLiteral(red: 0, green: 0.1568627451, blue: 0.3294117647, alpha: 1)
        
        static let a = UIColor(displayP3Red: 139 / 255, green: 194 / 255, blue: 255 / 255, alpha: 1)
        static let b = UIColor(displayP3Red: 92 / 255, green: 170 / 255, blue: 255 / 255, alpha: 1)
        static let c = UIColor(displayP3Red: 46 / 255, green: 146 / 255, blue: 255 / 255, alpha: 1)
        static let d = UIColor(displayP3Red: 23 / 255, green: 134 / 255, blue: 255 / 255, alpha: 1)
        static let e = UIColor(displayP3Red: 25 / 255, green: 115 / 255, blue: 213 / 255, alpha: 1)
        static let f = UIColor(displayP3Red: 0 / 255, green: 60 / 255, blue: 125 / 255, alpha: 1)
        
        struct Palette01 {
            static let mainBlue = UIColor(displayP3Red: 00 / 255, green: 109 / 255, blue: 229 / 255, alpha: 1)
            static let darkBlue = UIColor(displayP3Red: 00 / 255, green: 12 / 255, blue: 24 / 255, alpha: 1)
            static let charcoal = UIColor(displayP3Red: 44 / 255, green: 66 / 255, blue: 81 / 255, alpha: 1)
            static let lightCyan = UIColor(displayP3Red: 222 / 255, green: 255 / 255, blue: 252 / 255, alpha: 1)
            static let pureWhite = UIColor(displayP3Red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
//            static let pureWhite = UIColor.white
            static let gunMetal = UIColor(displayP3Red: 20 / 255, green: 20 / 255, blue: 20 / 255, alpha: 1)
//            static let gunMetal = UIColor.black
        }
    }
}
