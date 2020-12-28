//
//  TacoTableViewCell.swift
//  TacoFinder
//
//  Created by Luis Calvillo on 12/28/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import UIKit

class TacoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
