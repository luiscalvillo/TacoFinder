//
//  CustomUIView.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 1/3/21.
//  Copyright © 2021 Luis Calvillo. All rights reserved.
//

import UIKit

class CustomUIView: UIView {

    override func awakeFromNib() {
         self.layer.cornerRadius = 20
        
//        layer.borderColor = UIColor.green.cgColor
//        layer.borderWidth = 3
        
        layer.masksToBounds = false
             // dark
             let layer1 = CALayer()
             layer1.frame = layer.bounds
             layer1.cornerRadius = 20
//             layer1.backgroundColor = backgroundColor?.cgColor
             layer.insertSublayer(layer1, at: 0)
        
        // grey cells
//             layer1.applySketchShadow(color:  UIColor.black, alpha: 0.1, x: 10, y: 10, blur: 16, spread: 0)
        
        // white cell
             
//        layer1.applySketchShadow(color:  UIColor.black, alpha: 0.2, x: 9 ,y: 9, blur: 16, spread: 0)
             // light
        
        
            // black dark
            layer1.applySketchShadow(color:  UIColor.black, alpha: 0.2, x: 1 ,y: 1, blur: 8, spread: 0)

            
             
             let layer2 = CALayer()
             layer2.frame = layer.bounds
             layer2.cornerRadius = 20
//             layer2.backgroundColor = backgroundColor?.cgColor
             layer.insertSublayer(layer2, at: 0)
            // grey cells
//             layer2.applySketchShadow(color: UIColor.white, alpha: 0.1, x: -5, y: -5, blur: 16, spread: 0)
        
        
        // white cell
//        layer2.applySketchShadow(color: UIColor.white, alpha: 0.7, x: -9, y: -9, blur: 16, spread: 0)
        
        // black light
            layer2.applySketchShadow(color: UIColor.white, alpha: 0.1, x: -1, y: -1, blur: 8, spread: 0)

        
        
    }

}




