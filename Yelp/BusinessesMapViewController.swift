//
//  BusinessesMapViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/14/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    private let annotationReuseIdentifier = "Business"
    var businesses: [Business]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let businessesWithCoordinates = businesses.filter { (business) -> Bool in
            if let _ = business.latitude, let _ = business.longitude {
                return true
            }
            return false
        }
        
        let annotations = businessesWithCoordinates.map { (business) -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = business.name
            annotation.subtitle = business.address
            annotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            return annotation
        }
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:annotationReuseIdentifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            let detailButton = UIButton(type: .detailDisclosure)
            detailButton.addTarget(self, action: #selector(BusinessesMapViewController.showDetailVC), for: .touchUpInside)
            annotationView.rightCalloutAccessoryView = detailButton
            return annotationView
        }
    }
    
    func showDetailVC() {
        dismiss(animated: false) { 
            // Show new controller
        }
    }
}
