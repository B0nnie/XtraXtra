//
//  CAGradientLayer+Convenience.swift
//  XtraXtra
//
//  Created by Ebony Nyenya on 5/27/16.
//  Copyright © 2016 Ebony Nyenya. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func roseWaterColor() -> CAGradientLayer{
        
        let topColor = UIColor(red: 95/255.0, green: 195/255.0, blue: 228/255.0, alpha: 1)
        let bottomColor = UIColor(red: 229/255.0, green: 93/255.0, blue: 135/255.0, alpha: 1)
        
        let gradientColors = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations = [0.0, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }

}
