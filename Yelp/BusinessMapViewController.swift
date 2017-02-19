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

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Property declarations
    
    var businesses: [Business]!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationReuseIdentifier = "BusinessLocation"
        
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
                        performSegue(withIdentifier: C.Identifier.Segue.businessDetailVC, sender: business)
                    }
                }
            }
        }
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
