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

    var business: Business!
    
    private(set) var ratingInformationAvailable = false
    
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let imageURL = business.imageURL {
            businessImageView.setImageWith(imageURL)
            
            /*
                AFNetworking appears not to work with Aspect Fill directly
                (image will go out of bound), but Content Fill and Aspect
                Fill do work normally.
             */
            businessImageView.contentMode = .scaleAspectFill
            businessSectionView.clipsToBounds = true
        }
        
        businessNameLabel.text = business.name
        if let rating = business.rating,
            let reviewCount = business.reviewCount as? Int {
            ratingLabel.text = "\(rating) with \(reviewCount) reviews"
            ratingInformationAvailable = (reviewCount > 0)
        } else {
            ratingLabel.text = "Review information not available"
        }
        
        phoneNumberLabel.text = "Phone: \(business.displayPhone ?? "(to be added)")"
        
        distanceLabel.text = business.distance
        categoriesLabel.text = business.categories
        
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
        
        if ratingInformationAvailable {
            loadReviews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
        businessImageView.layoutIfNeeded()
    }
    
    private func loadReviews() {
        
        if ratingInformationAvailable {
            
            if let id = business.id {
                Business.searchWithBusinessId(id: id) { (business, error) in
                    if let business = business, let reviews = business["reviews"] as? [[String: AnyObject]] {
                        
                        // Yelp API only shows one review
                        let review = reviews.first
                        
                        self.customerNameLabel.text = review?["user"]?["name"] as? String
                        if let rating = review?["rating"] as? Double {
                            self.customerRatingLabel.text = "\(rating)"
                        } else {
                            self.customerRatingLabel.text = "--"
                        }
                        self.customerReviewTextView.text = review?["excerpt"] as? String
                    }
                }
            }
        }
    }
}
