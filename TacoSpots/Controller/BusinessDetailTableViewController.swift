//
//  BusinessDetailTableViewController.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 12/31/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var directionsButton: UIButton!
    var name = ""
    var address = ""
    var distance = 0.0
    var latitude = 0.0
    var longitude = 0.0
    
    var currentLocation = [0.0, 0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        addressLabel.text = address
        distanceLabel.text = "\(distance)"
        
        mapView.layer.cornerRadius = 20
        
        directionsButton.layer.cornerRadius = 20
    
        showMapLocationFromCoordinates()
     
    }
    
    // MARK - IBActions
    
    @IBAction func directionsButtonWasPressed(_ sender: Any) {
        goToAppleMaps()
    }
    
    
    
    func goToAppleMaps() {
        
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation[0], longitude: currentLocation[1])))
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        
        destination.name = name
        
        let yourLocation = CLLocation(latitude: currentLocation[0], longitude: currentLocation[1])
        let businessLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        let distance = businessLocation.distance(from: yourLocation)
        
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    
    func showMapLocationFromCoordinates() {
        
        var region = MKCoordinateRegion()
        
        region.center.latitude = latitude
        region.center.longitude = longitude
        
        region.span.latitudeDelta = 0.001
        region.span.longitudeDelta = 0.001
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        mapView.isPitchEnabled = false
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        
        self.mapView.addAnnotation(annotation)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return 375
            } else if indexPath.row == 1 {
                return 100
            } else if indexPath.row == 2 {
                
                return 152
                
            } else if indexPath.row == 3 {
                
                return 92
                
            }
        }
        
        return 100
    }

 

}
