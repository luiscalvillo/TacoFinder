//
//  FetchBusinessData.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 12/30/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import Foundation

var businessList: [Business] = []
extension HomeViewController {
     
    
    func retrieveBusinesses(latitude: Double, longitude: Double, category: String, limit: Int, sortBy: String, locale: String, completionHandler: @escaping ([Business]?, Error?) -> Void) {
        
        let apiKey = "YOUR_API_KEY"
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"
        let url = URL(string: baseURL)
        
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        // Initialize session and task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completionHandler(nil, error)
            }
            
            do {
                // Read JSON
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
               
                // Main dictionary
                guard let resp = json as? NSDictionary else { return }
               
                // Businesses
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
               
//                var businessList: [Business] = []
               
                // access each business
                for business in businesses {
                    var place = Business()
                    place.name = business.value(forKey: "name") as? String
                    place.id = business.value(forKey: "id") as? String
                    place.distance = business.value(forKey: "distance") as? Double
                    place.imageURL = business.value(forKey: "image_url") as? String
                    let address = business.value(forKeyPath: "location.display_address") as? [String]

                    place.address = address?.joined(separator: "\n")
                    
                    let coordinates = business.value(forKey: "coordinates") as? [String : Double]
                    
                    place.coordinates = coordinates
                    
                    place.latitude = coordinates!["latitude"] as! Double
                    place.longitude = coordinates!["longitude"] as! Double
                    place.isClosed = business.value(forKey: "is_closed") as? Bool
                    place.hours = business.value(forKey: "hours") as? [String : Any]
                    place.isOpenNow = business.value(forKeyPath: "hours.is_open_now") as? Bool
                   

                    businessList.append(place)
                    print("place lat lat = \(place)")
                }
               
                completionHandler(businessList, nil)
            } catch {
            print("Caught error")
            completionHandler(nil, error)
            }}.resume()
    }
}
