//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/14/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController, MKMapViewDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var businessImageView: UIImageView!
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerRatingLabel: UILabel!
    @IBOutlet weak var customerReviewTextView: UITextView!
    
    @IBOutlet weak var businessSectionView: UIView!
    
    // MARK: - Property declarations
    
    var business: Business!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    // MARK: - Helper methods
    
    private func prepareUI () {
        
        // Business background image (blurry due to Yelp API limitation)
        if let imageURL = business.imageURL {
            businessImageView.setImageWith(imageURL)
            
            /*
             AFNetworking appears not to work with Aspect Fill directly
             (image will go out of bound), but Content Fill and Aspect
             Fill do work normally. So clipsToBounds is used here
             */
            businessImageView.contentMode = .scaleAspectFill
            businessSectionView.clipsToBounds = true
        }
        
        // Business name
        businessNameLabel.text = business.name
        
        // Business rating (score AND number of reviews)
        ratingLabel.text = business.ratingText
        
        // Business phone number
        phoneNumberLabel.text = "Phone: \(business.displayPhone ?? "(to be added)")"
        
        // Distance (in miles)
        distanceLabel.text = business.distance
        
        // Business categories
        categoriesLabel.text = business.categories
        
        // Business showing on the map
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layer.cornerRadius = 8.0
        mapView.clipsToBounds = true
        
        if let latitude = business.latitude, let longitude = business.longitude {
            let annotation: MKAnnotation = {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                return annotation
            }()
            
            mapView.showAnnotations([annotation], animated: false)
            addressLabel.text = business.address
        } else {
            addressLabel.text = "Address not available"
        }
        
        // Business review (if any) - Yelp API only returns one
        loadReview()
    }
    
    private func loadReview() {
        
        typealias ReviewJSONKey = N.JSONKey.Business.CustomerReview
        
        if let reviewCount = business.reviewCount as? Int, reviewCount > 0 {
            if let id = business.id {
                Business.searchWithBusinessId(id: id) { (business, error) in
                    if let business = business,
                        let reviews = business[ReviewJSONKey.reviews] as? [[String: AnyObject]],
                        let review = reviews.first {
                        
                        self.customerNameLabel.text =
                            review[ReviewJSONKey.userInfo]?[ReviewJSONKey.userName] as? String
                        if let rating = review[ReviewJSONKey.rating] as? Double {
                            self.customerRatingLabel.text = "\(rating)"
                        } else {
                            self.customerRatingLabel.text = N.loadingText
                        }
                        self.customerReviewTextView.text = review[ReviewJSONKey.reviewText] as? String
                    }
                }
            }
        } else {
            self.customerNameLabel.text = ""
            self.customerRatingLabel.text = ""
            self.customerReviewTextView.text = "No review yet"
        }
    }
}
