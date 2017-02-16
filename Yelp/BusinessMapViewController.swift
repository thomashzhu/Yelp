//
//  BusinessMapViewController.swift
//  Yelp
//
//  Created by Thomas Zhu on 2/14/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessMapViewController: UIViewController, MKMapViewDelegate {

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
            let annotation = IdentifiableAnnotation(identifier: business.id,
                                                    title: business.name,
                                                    subtitle: business.address,
                                                    coordinate: CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!))
            return annotation
        }
        
        mapView.showAnnotations(annotations, animated: true)
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
            annotationView.rightCalloutAccessoryView = detailButton
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let selectedAnnotation = view.annotation as? IdentifiableAnnotation {
                if let selectedBusinessId = selectedAnnotation.identifier {
                    let selectedBusinesses = businesses.filter { (business) -> Bool in
                        if business.id == selectedBusinessId {
                            return true
                        }
                        return false
                    }
                    
                    if let business = selectedBusinesses.first {
                        self.performSegue(withIdentifier: "BusinessDetailViewController", sender: business)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BusinessDetailViewController" {
            if let vc = segue.destination as? BusinessDetailViewController {
                if let business = sender as? Business {
                    vc.business = business
                }
            }
        }
    }
}
