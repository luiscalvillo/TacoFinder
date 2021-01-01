//
//  HomeViewController.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 12/28/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage

class HomeViewController: UIViewController {
   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    let CPLatitude: Double = 40.782483
    let CPLongitude: Double = -73.963540
    
    var latitude = 0.0
    var longitude = 0.0
    
    
    
    var locationManager: CLLocationManager?
    
    var businesses: [Business] = []
    

    
    
    // MARK - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager = CLLocationManager()
        mapView.delegate = self
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        retrieveBusinesses(latitude: latitude, longitude: longitude, category: "tacos", limit: 5, sortBy: "distance", locale: "en_US") { (response, error) in
            
            if let response = response {
                self.businesses = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("businesses = \(self.businesses.count)")
                }
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.mapView.alpha = 1
            self.tableView.alpha = 0
        }
    }

    
 // MARK: - IBActions


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
         return businesses.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TacoTableViewCell
        cell.restaurantNameLabel.text = businesses[indexPath.row].name
        cell.addressLabel.text = businesses[indexPath.row].address
        cell.distanceLabel.text = "\(businesses[indexPath.row].distance)"
        
        let businessImageUrl = businesses[indexPath.row].imageURL
        let imageView: UIImageView = cell.businessImageView
    
        imageView.sd_setImage(with: URL(string: businessImageUrl!), placeholderImage: nil)
        
        
        return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 132
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let businessDetailVC = storyboard.instantiateViewController(withIdentifier: "BusinessDetailTableViewController") as! BusinessDetailTableViewController
        
        let business = businesses[indexPath.row]
        

        // FIXME: - remove force unwraps
        
        businessDetailVC.name = business.name!
        businessDetailVC.address = business.address!
        
        self.navigationController?.pushViewController(businessDetailVC, animated: true)
        
    }
    
    
}



extension HomeViewController: MKMapViewDelegate {
    
    
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
}

