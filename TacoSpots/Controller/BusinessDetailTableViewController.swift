//
//  BusinessDetailTableViewController.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 12/31/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import UIKit

class BusinessDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var name = ""
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        addressLabel.text = address
     
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return 400
            } else if indexPath.row == 1 {
                return 100
            }
        }
        
        return 100
    }

 

}
