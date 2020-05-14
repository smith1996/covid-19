//
//  ULoaderManager.swift
//  PruebaYOY
//
//  Created by Smith Huamani Hilario on 1/16/20.
//  Copyright © 2020 YOY. All rights reserved.
//

import UIKit

class ULoaderManager {
    
    static let shared: ULoaderManager = {
        let instance = ULoaderManager()
        return instance
    }()
    
    var arrayLoaders: NSMutableArray = []
    var arrayCircles: NSMutableArray = []
    
    private var loaderContainer: UIView?
    private var circle: UIActivityIndicatorView?
    
    init() {
        loaderContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        loaderContainer!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let frameCircleView = CGRect(x: (UIScreen.main.bounds.size.width / 2) - 15, y: (UIScreen.main.bounds.size.height / 2) - 15, width: 30, height: 30)
        circle = UIActivityIndicatorView(frame: frameCircleView)
    }
    
    public func presentLoad() {
        
        DispatchQueue.main.async {
            guard let loaderView = self.loaderContainer else { return }
            guard let circleView = self.circle else { return }
            
            loaderView.addSubview(circleView)
            UIApplication.shared.keyWindow?.addSubview(loaderView)
            circleView.startAnimating()
            self.arrayLoaders.add(loaderView)
            self.arrayCircles.add(circleView)
        }
    }
    
    public func removeLoad() {
        DispatchQueue.main.async {
            self.arrayCircles.forEach { ($0 as! UIActivityIndicatorView).stopAnimating() }
            self.arrayLoaders.forEach { ($0 as! UIView).removeFromSuperview() }
        }
    }
    
}
