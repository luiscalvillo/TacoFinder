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
    
    // Popup view
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    @IBOutlet weak var businessDistanceLabel: UILabel!
    
    @IBOutlet weak var businessPopupView: UIView!
    @IBOutlet weak var popupViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var permissionsPopupView: CustomUIView!
   
    
    var isPopupViewVisible = false
    
    var latitude = 0.0
    var longitude = 0.0
    
    var currentLocation = [0.0, 0.0]
    
    var locationManager: CLLocationManager?
    
    var businesses: [Business] = []
    
    var customPointAnnotation: CustomPointAnnotation!
    var selectedAnnotation: CustomPointAnnotation?

    var mapViewIsVisible = true
    var listViewIsVisible = false
    var permissionsViewIsVisible = false
    
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.mapView.addGestureRecognizer(tap)
        
        let popupViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePopupViewScreenTap(sender:)))
        businessPopupView.addGestureRecognizer(popupViewTapGesture)
        
        setupNavigationBar()
        
        hidePermissionsView()
        
        self.segmentedControl.setEnabled(false, forSegmentAt: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            
            if self.mapViewIsVisible == true {
                self.mapView.alpha = 1
                self.tableView.alpha = 0
            } else {
                self.mapView.alpha = 0
                self.tableView.alpha = 1
            }
            
        }
        
        setupSegmentedControlView()
        setupBusinessPopupView()
    }
    
  
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        hidePopupView()
    }
    
    @objc func handlePopupViewScreenTap(sender: UITapGestureRecognizer) {
        goToBusinessDetailVC()
    }
    
    func setupBusinessPopupView() {
        
        isPopupViewVisible = false
        popupViewBottomConstraint.constant = -150
        self.view.layoutIfNeeded()
    }
    
    func setupSegmentedControlView() {
        // selected option color
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

        // color of other options
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        let font: [AnyHashable : Any] = [NSAttributedString.Key.font : UIFont(name: "GillSans", size: 16)]
        segmentedControl.setTitleTextAttributes(font as! [NSAttributedString.Key : Any], for: .normal)
    }

    
    func setupNavigationBar() {
        
        let logo = UIImage(named: "tacospots-logo")
    
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
    }
    
    
    func showPermissionsView() {
        permissionsPopupView.isHidden = false
        permissionsViewIsVisible = true
    }
    
    func hidePermissionsView() {
        permissionsPopupView.isHidden = true
        permissionsViewIsVisible = false
    }
    
 // MARK: - IBActions
    
    @IBAction func segmentedControlIndexValueWasChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
        
            UIView.animate(withDuration: 0.5) {
                self.mapView.alpha = 1
                self.tableView.alpha = 0
                
                self.mapViewIsVisible = true
                self.listViewIsVisible = false
            }
        case 1:
            UIView.animate(withDuration: 0.5) {
                self.mapView.alpha = 0
                self.tableView.alpha = 1
                
                self.mapViewIsVisible = false
                self.listViewIsVisible = true
            }
        default:
            break
        }
    }
    
    
    @IBAction func goToSettingsButtonWasPressed(_ sender: Any) {
        goToDeviceSettings()
    }
    
  
    func goToDeviceSettings() {
      if let url = URL(string: UIApplication.openSettingsURLString) {
          
          if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
      }
    }
  
    func addBusinessesToMap() {
        
        for business in businessList {
            
            customPointAnnotation = CustomPointAnnotation()
            customPointAnnotation.title = business.name
            customPointAnnotation.address = business.address
            customPointAnnotation.imageUrl = business.imageURL
            customPointAnnotation.latitude = business.latitude
            customPointAnnotation.longitude = business.longitude
            customPointAnnotation.distance = business.distance
            customPointAnnotation.isClosed = business.isClosed
            customPointAnnotation.hours = business.hours
        
            if let lat = business.coordinates!["latitude"], let lon = business.coordinates!["longitude"] {
                customPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                mapView.addAnnotation(customPointAnnotation)
            }
        }
    }
    
    
    func showPopupView() {
        
        isPopupViewVisible = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.popupViewBottomConstraint.constant = 32
        }, completion: nil)
    }
    
    func hidePopupView() {
        
        isPopupViewVisible = false
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.popupViewBottomConstraint.constant = -150
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

}


// MARK: - Extensions

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return businesses.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TacoTableViewCell
        let business = businesses[indexPath.row]
        
        cell.restaurantNameLabel.text = business.name
        cell.addressLabel.text = business.address
        cell.distanceLabel.text = "\(String(describing: business.distance?.getMiles())) mi"

        let businessDistanceInMiles = business.distance!.getMiles()
        let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles * 100) / 100)
        
        cell.distanceLabel.text = roundedDistanceInMiles + " mi"
        
        let businessImageUrl = businesses[indexPath.row].imageURL
        let imageView: UIImageView = cell.businessImageView
    
        imageView.sd_setImage(with: URL(string: businessImageUrl!), placeholderImage: nil)
        
        return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 148
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let businessDetailVC = storyboard.instantiateViewController(withIdentifier: "BusinessDetailTableViewController") as! BusinessDetailTableViewController
        
        let business = businesses[indexPath.row]
        
        // FIXME: - remove force unwraps
        
        businessDetailVC.name = business.name!
        businessDetailVC.address = business.address!
        businessDetailVC.distance = business.distance!
        businessDetailVC.latitude = business.latitude!
        businessDetailVC.longitude = business.longitude!
        businessDetailVC.imageUrl = business.imageURL!
        
        
        print("tapped on cell")
        
        self.navigationController?.pushViewController(businessDetailVC, animated: true)
    }
}



extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.canShowCallout = true
        
        annotationView.annotation = annotation
        
        annotationView.image = UIImage(named: "tacoPlacemarker")
        annotationView.frame.size = CGSize(width: 40, height: 40)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? CustomPointAnnotation else { return }
        
        self.selectedAnnotation = annotation
        
        if isPopupViewVisible == false {
            
            showPopupView()
            
            if view .isKind(of: MKUserLocation.self) {
                 businessNameLabel.text = "My Location"
            } else {
                 
                businessNameLabel.text = selectedAnnotation?.title
                businessAddressLabel.text = selectedAnnotation?.address
               
                let businessDistanceInMiles = selectedAnnotation?.distance.getMiles()
                let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles! * 100) / 100)
                
                businessDistanceLabel.text = roundedDistanceInMiles + " mi"
 
                let businessImageUrl = selectedAnnotation?.imageUrl ?? ""
                let imageView: UIImageView = self.businessImageView
                imageView.sd_setImage(with: URL(string: businessImageUrl), placeholderImage: nil)
            }
        } else {
            hidePopupView()
        }
    }
    
    func goToBusinessDetailVC() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let businessVC = storyboard.instantiateViewController(identifier: "BusinessDetailTableViewController") as! BusinessDetailTableViewController
        
        businessVC.name = selectedAnnotation!.title!
        businessVC.address = selectedAnnotation!.address
        businessVC.imageUrl = selectedAnnotation!.imageUrl
        businessVC.latitude = selectedAnnotation!.latitude
        businessVC.longitude = selectedAnnotation!.longitude
        businessVC.distance = selectedAnnotation!.distance
        businessVC.isClosed = selectedAnnotation!.isClosed
        
        self.navigationController?.pushViewController(businessVC, animated: true)
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            mapView.isZoomEnabled = true
            
            if permissionsViewIsVisible == true {
                hidePermissionsView()
            }
         
            DispatchQueue.main.async {
                
                self.retrieveBusinesses(latitude: self.latitude, longitude: self.longitude, category: "tacos", limit: 30, sortBy: "distance", locale: "en_US") { (response, error) in

                    if let response = response {
                        self.businesses = response
                        DispatchQueue.main.async { [self] in
                            self.tableView.reloadData()
                            self.addBusinessesToMap()
                            self.locationManager?.stopUpdatingLocation()
                            
                            self.segmentedControl.setEnabled(true, forSegmentAt: 1)
                        }
                    }
                }
            }
            
        } else {
            showPermissionsView()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            currentLocation = [latitude, longitude]
        }
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var name: String!
    var address: String!
    var coordinates: [String : Double]!
    var imageUrl: String!
    var latitude: Double!
    var longitude: Double!
    var distance: Double!
    var isClosed: Bool!
    var hours: [String : Any]!
}

extension Double {
    func getMiles() -> Double {
        return self * 0.000621371191
    }
}
