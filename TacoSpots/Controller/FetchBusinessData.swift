//
//  FetchBusinessData.swift
//  TacoSpots
//
//  Created by Luis Calvillo on 12/30/20.
//  Copyright © 2020 Luis Calvillo. All rights reserved.
//

import Foundation

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
               
                var businessList: [Business] = []
               
                // access each business
                for business in businesses {
                    var place = Business()
                    place.name = business.value(forKey: "name") as? String
                    place.id = business.value(forKey: "id") as? String
                    place.distance = business.value(forKey: "distance") as? Double
                    let address = business.value(forKeyPath: "location.display_address") as? [String]
                    place.address = address?.joined(separator: "\n")
                    
                    businessList.append(place)
                }
               
                completionHandler(businessList, nil)
            } catch {
            print("Caught error")
            completionHandler(nil, error)
            }}.resume()
        
    }
    
}