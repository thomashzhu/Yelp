//
//  BusinessMapViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/14/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessMapViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Property declarations
    
    var businesses: [Business]!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = BusinessMapViewDelegate(context: self)
        mapView.showsUserLocation = true
        
        let annotations = businesses.reduce([]) { (result, business) -> [IdentifiableAnnotation] in
            if let latitude = business.latitude, let longitude = business.longitude {
                let annotation = IdentifiableAnnotation(identifier: business.id,
                                                        title: business.name,
                                                        subtitle: business.address,
                                                        coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                return result + [annotation]
            }
            return result
        }
        mapView.showAnnotations(annotations, animated: true)
    }
    
    // MARK: - Helper methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.Identifier.Segue.businessDetailVC {
            if let vc = segue.destination as? BusinessDetailViewController {
                if let business = sender as? Business {
                    vc.business = business
                }
            }
        }
    }
}
