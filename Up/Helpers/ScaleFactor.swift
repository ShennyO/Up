//
//  ScaleFactor.swift
//  Up
//
//  Created by Sunny Ouyang on 5/9/19.
//

import Foundation
import UIKit

public func heightScaleFactor(distance: CGFloat) -> CGFloat {
    let phoneHeight = UIScreen.main.bounds.height
    var scaleFactor: CGFloat = 1
    
    scaleFactor = distance / 736
    let scaledDistance = phoneHeight * scaleFactor
    
    return scaledDistance
}

public func widthScaleFactor(distance: CGFloat) -> CGFloat {
    let phoneWidth = UIScreen.main.bounds.width
    var scaleFactor: CGFloat = 1
    
    scaleFactor = distance / 414
    let scaledDistance = phoneWidth * scaleFactor
    
    return scaledDistance
}
