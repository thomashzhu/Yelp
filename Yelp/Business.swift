//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    
    // Map Page
    let id: String?
    let latitude: Double?
    let longitude: Double?
    
    // Details Page
    let displayPhone: String?
    let url: String?
    let rating: Double?
    let reviews: [[String: AnyObject]]?
    let ratingText: String
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        
        // Map Page
        
        id = dictionary["id"] as? String
        
        if let location = dictionary["location"] as? NSDictionary,
           let coordinate = location["coordinate"] as? NSDictionary {
            latitude = coordinate["latitude"] as? Double
            longitude = coordinate["longitude"] as? Double
        } else {
            latitude = nil
            longitude = nil
        }
        
        // Details page
        
        displayPhone = dictionary["display_phone"] as? String
        url = dictionary["url"] as? String
        rating = dictionary["rating"] as? Double
        reviews = dictionary["reviews"] as? [[String: AnyObject]]
        
        if let rating = rating, let reviewCount = reviewCount as? Int {
            let ratingNumber = (whole: Int(modf(rating).0), half: Int(modf(rating).1 / 0.5))
            let wholeStars = String(repeating: "\u{2730}", count: ratingNumber.whole)
            let halfStar = String(repeating: "\u{00BD}", count: ratingNumber.half)
            ratingText = "\(wholeStars + halfStar)  (\(reviewCount) reviews)"
        } else {
            ratingText = "Review information not available"
        }
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, location: String?, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, location: location, sort: sort, categories: categories, deals: deals, completion: completion)
    }
    
    class func searchWithBusinessId(id: String, completion: @escaping ([String: Any]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithBusinessId(id, completion: completion)
    }
}
