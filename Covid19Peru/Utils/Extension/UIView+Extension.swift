//
//  View+Extension.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/7/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit

extension UIView {
    
    public func addShadowViewCustom(cornerRadius: CGFloat, opacity: Float = 0.2, radius: CGFloat = 5) {
        
        self.layer.cornerRadius = cornerRadius//viewCustom.bounds.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
