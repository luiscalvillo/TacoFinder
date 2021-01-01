//
//  RoundedImageView.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 12/31/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    override func awakeFromNib() {
        setupView()
    }

    
    func setupView() {
        
        self.layer.cornerRadius = 20
        
        
    }
}
