//
//  BusinessMapViewDelegate.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class BusinessMapViewDelegate: NSObject, MKMapViewDelegate {
    
    private let annotationReuseIdentifier = "BusinessLocation"
    
    // MARK: Context
    
    private let vc: BusinessMapViewController
    
    // MARK: Initializer
    
    init(context vc: BusinessMapViewController) {
        self.vc = vc
    }
    
    // MARK: Delegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:annotationReuseIdentifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = detailButton
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let selectedAnnotation = view.annotation as? IdentifiableAnnotation {
                if let selectedBusinessId = selectedAnnotation.identifier {
                    let selectedBusinesses = vc.businesses.filter { (business) -> Bool in
                        if business.id == selectedBusinessId {
                            return true
                        }
                        return false
                    }
                    
                    if let business = selectedBusinesses.first {
                        vc.performSegue(withIdentifier: C.Identifier.Segue.businessDetailVC, sender: business)
                    }
                }
            }
        }
    }
}
