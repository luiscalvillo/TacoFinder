//
//  CustomButton.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 1/3/21.
//  Copyright © 2021 Luis Calvillo. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        
        layer.masksToBounds = false
        // dark
        let layer1 = CALayer()
        layer1.frame = layer.bounds
        layer1.cornerRadius = layer1.frame.height / 2
        layer1.backgroundColor = backgroundColor?.cgColor
        layer.insertSublayer(layer1, at: 1)
        layer1.applySketchShadow(color:  UIColor.black, alpha: 0.1, x: 10, y: 10, blur: 16, spread: 0)
        
        // light
       
        let layer2 = CALayer()
        layer2.frame = layer.bounds
        layer2.cornerRadius = layer2.frame.height / 2
        layer2.backgroundColor = backgroundColor?.cgColor
        layer.insertSublayer(layer2, at: 0)
        layer2.applySketchShadow(color: UIColor.white, alpha: 0.1, x: -5, y: -5, blur: 16, spread: 0)

    }
    
    
    func addShadows() {
        self.layer.masksToBounds = false

        let cornerRadius: CGFloat = 15
        let shadowRadius: CGFloat = 4

        let darkShadow = CALayer()
        darkShadow.frame = bounds
        darkShadow.backgroundColor = backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0).cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
    
        self.layer.insertSublayer(darkShadow, at: 0)

        let lightShadow = CALayer()
        lightShadow.frame = bounds
        lightShadow.backgroundColor = backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0).cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
        self.layer.insertSublayer(lightShadow, at: 0)
    }

}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 1,
        x: CGFloat = 6,
        y: CGFloat = 6,
        blur: CGFloat = 10,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        masksToBounds = false
    }
}

