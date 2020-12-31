//
//  HomeViewController.swift
//  TacoFinder
//
//  Created by Luis Calvillo on 12/28/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let tableViewData = Array(repeating: "Item", count: 5)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.mapView.alpha = 1
            self.tableView.alpha = 0
        }
    }



    @IBAction func segmentedControlIndexValueWasChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
        
            UIView.animate(withDuration: 0.5) {
                self.mapView.alpha = 1
                self.tableView.alpha = 0
            }
        case 1:
            UIView.animate(withDuration: 0.5) {
                self.mapView.alpha = 0
                self.tableView.alpha = 1
            }
        default:
            break
        }
    }
    
}


// MARK: - Extensions

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tableViewData.count
    }
        
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TacoTableViewCell
         cell.restaurantNameLabel.text = "Taco Shop!"
         cell.addressLabel.text = self.tableViewData[indexPath.row]
         return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 132
     }
}
